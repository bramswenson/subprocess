module Subprocess
  class Popen
    include Timeout

    attr_accessor :command, :pid, :stdout, :stderr, :status

    def initialize(command, timeout=30)
      @command = command
      @timeout = timeout
      @running = false
      @ipc_parsed = false
    end

    def running?
      return false unless @parent_pid
      return @running unless @running
      begin
        Process.kill(0, @parent_pid)
        @running = true
      rescue Errno::ESRCH
        @running = false
      end
      parse_ipc_pipe unless (@running or @ipc_parsed)
      @running
    end

    def pid
      defined?(:@status) ? @status[:pid] : false
    end

    def run
      setup_pipes
      # record the time and fork off the command
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
      @parent_pid, parent_status = Process.wait2(@parent_pid)
      @running = false
      parse_ipc_pipe unless @ipc_parsed
    end

    private
    def setup_pipes
      # setup stream pipes and a pipe for interprocess communication
      @stdin_rd, @stdin_wr = IO::pipe
      @stdout_rd, @stdout_wr = IO::pipe
      @stderr_rd, @stderr_wr = IO::pipe
      @ipc_rd, @ipc_wr = IO::pipe
    end

    def fork_parent
      Kernel.fork {
        redirect_stdstreams
        report_child_status_to_parent(fork_child)
        teardown_pipes
      }
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
          child_pid = Kernel.fork{ fork_child_exec }
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

