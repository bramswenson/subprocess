module Subprocess
  class Popen
    include Timeout

    attr_accessor :command, :stdout, :stderr, :status

    def initialize(command, callbacks=nil, timeout=300)
      @command = command
      @timeout = timeout
      # callback should be a hash keyed with the method/proc to
      # be called and with a list of args to call with the
      # callback { :somemeth => [ 'somearg', 'someother_arg' ]
      # would end up with
      # somemeth('somearg', 'someother_arg')
      @callbacks = callbacks
      @running = false
      @ipc_parsed = false
    end

    def running?
      # return false if no parent pid or if running is already false
      return false unless @parent_pid
      return @running unless @running

      begin
        # see if the process is running or not
        Process.kill(0, @parent_pid)
        # since we didn't error then we have a pid running
        # so lets see if is over after less than .5 seconds
        begin
          timeout(0.5) do
            @parent_pid, parent_status = Process.wait2(@parent_pid, 0)
          end
        rescue Timeout::Error
          # wait timed out so so pid is stll running
          @running = true
        end
        # no timeout so pid is finished
        @running = false
      rescue Errno::ESRCH
        # Process.kill says the pid is not found
        @running = false
      end

      # parse the child status if pid is complete
      parse_ipc_pipe unless (@running or @ipc_parsed)
      @running
    end

    def run_time
      defined?(:@status) ? @status[:run_time] : false
    end

    def pid
      defined?(:@status) ? @status[:pid] : false
    end

    def perform
      # delayed job anyone?
      run unless running?
      wait
    end

    def run
      setup_pipes
      # record the time, set running and fork off the command
      @start_time = Time.now.to_f
      @running = true
      @parent_pid = fork_parent

      # close up the pipes
      [ @stdin_rd, @stdout_wr, @stderr_wr, @ipc_wr ].each do |p|
        p.close
      end

      # make sure sure the stdin_wr handle is sync
      @stdin_wr.sync = true
    end

    def wait
      # block until the process completes
      @parent_pid, parent_status = Process.wait2(@parent_pid)
      @running = false
      parse_ipc_pipe unless @ipc_parsed
    end

    def active_record?
      Module.constants.include?("ActiveRecord")
    end

    private
    def run_callbacks
      return unless @callbacks
      @callbacks.each do |meth,args|
        meth.call(*args)
      end
    end

    def setup_pipes
      # setup stream pipes and a pipe for interprocess communication
      @stdin_rd, @stdin_wr = IO::pipe
      @stdout_rd, @stdout_wr = IO::pipe
      @stderr_rd, @stderr_wr = IO::pipe
      @ipc_rd, @ipc_wr = IO::pipe
    end

    def ar_remove_connection
      ActiveRecord::Base.remove_connection
    end
    
    def ar_establish_connection(dbconfig)
      ActiveRecord::Base.establish_connection(dbconfig)
    end

    def fork_parent
      dbconfig = ar_remove_connection if active_record?
      pid = Kernel.fork {
        ar_establish_connection(dbconfig) if active_record?
        begin
          redirect_stdstreams
          report_child_status_to_parent(fork_child)
          teardown_pipes
        ensure
          ar_remove_connection if active_record?
        end
      }
      ar_establish_connection(dbconfig) if active_record?
      pid
    end

    def redirect_stdstreams
      # close the pipes we don't need
      [ @stdin_wr, @stdout_rd, @stderr_rd ].each do |p|
        p.close
      end

      # redirect this forks std streams into pipes
      STDIN.reopen(@stdin_rd)
      STDOUT.reopen(@stdout_wr)
      STDERR.reopen(@stderr_wr)
    end

    def fork_child
      child_status = Hash.new
      child_pid = nil
      start_time = Time.now.to_f
      begin
        timeout(@timeout) do
          dbconfig = ar_remove_connection if active_record?
          begin
            child_pid = Kernel.fork{ 
              fork_child_exec 
            }
          ensure
            ar_establish_connection(dbconfig) if active_record?
          end
          child_status = Process.wait2(child_pid)[1]
        end
      rescue Timeout::Error
        begin
          Process.kill('KILL', child_pid)
        rescue Errno::ESRCH
        end
        child_status[:exitstatus] = 1
        child_status[:timed_out?] = true
      end
      run_callbacks
      child_status = child_status.to_hash
      child_status[:run_time] = Time.now.to_f - start_time
      child_status
    end

    def report_child_status_to_parent(child_status)
      @ipc_wr.write child_status.to_json
      @ipc_wr.flush
    end

    def teardown_pipes
      # close pipes
      [ @stdin_rd, @stdout_wr, @stderr_wr, @ipc_wr ].each do |p|
        p.close
      end
    end

    def fork_child_exec
      Kernel.exec(@command)
    end

    def parse_ipc_pipe
      @status = JSON.parse(@ipc_rd.read).symbolize_keys
      @stdout, @stderr = @stdout_rd.read.chomp, @stderr_rd.read.chomp
      @stdout_rd.close; @stderr_rd.close; @ipc_rd.close
      @ipc_parsed = true
    end

  end # class Popen
end # module Subprocess

