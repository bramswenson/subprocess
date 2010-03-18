module Process
  class Status
    def to_hash
      { :exited? => exited?, :exitstatus => exitstatus, :pid => pid, 
        :stopped? => stopped?, :stopsig => stopsig, :success? => success?,
        :termsig => termsig, :timed_out? => false }
    end
    def to_json
      to_hash.to_json
    end
  end
end

class Hash
  # str8 from activesupport core_ext/hash/keys.rb
  def symbolize_keys
    inject({}) do |options, (key, value)|
      options[(key.to_sym rescue key) || key] = value
      options
    end
  end
  def symbolize_keys!
    self.replace(self.symbolize_keys)
  end
end

module Subprocess
  class Popen
    include Timeout
    attr_accessor :command, :parent_pid, :pid, :stdout, :stderr, :status, :raw_status

    def initialize(command, timeout=30)
      @command = command
      @timeout = timeout
      @running = false
    end

    def running?
      @running
    end

    def run
      # heavly influenced by open3.popen3
      # http://ruby-doc.org/stdlib/libdoc/open3/rdoc/index.html
      stdin_rd, stdin_wr = IO::pipe
      @stdout_rd, stdout_wr = IO::pipe
      @stderr_rd, stderr_wr = IO::pipe
      # a pipe for interprocess communication
      @ipc_rd, ipc_wr = IO::pipe
      @start_time = Time.now.to_f
      @pid = Kernel.fork {
        # close the pipes we don't need
        stdin_wr.close
        @stdout_rd.close
        @stderr_rd.close
        # redirect this forks std streams into pipes
        STDIN.reopen(stdin_rd)
        STDOUT.reopen(stdout_wr)
        STDERR.reopen(stderr_wr)

        @child_status = Hash.new
        @child_pid = nil
        start_time = Time.now.to_f
        begin
          timeout(@timeout) do
            @child_pid = Kernel.fork{ exec_popen }
            @child_status = Process.wait2(@child_pid)[1]
          end
        rescue Timeout::Error
          begin
            Process.kill('KILL', @child_pid)
          rescue Errno::ESRCH
          end
          @child_status[:exitstatus] = 1
          @child_status[:timed_out?] = true
        end
        @child_status = @child_status.to_hash
        @child_status[:run_time] = Time.now.to_f - start_time
        ipc_wr.write @child_status.to_json
        ipc_wr.flush
        # close pipes
        stdin_rd.close
        stdout_wr.close
        stderr_wr.close
        ipc_wr.close
      }
      stdin_rd.close
      stdout_wr.close
      stderr_wr.close
      ipc_wr.close
      stdin_wr.sync = true
    end

    def wait
      @pid, @parent_status = Process.wait2(@pid)
      @running = false
      @status = JSON.parse(@ipc_rd.read).symbolize_keys
      @stdout, @stderr = @stdout_rd.read.chomp, @stderr_rd.read.chomp
      @stdout_rd.close; @stderr_rd.close; @ipc_rd.close
    end

    private
    def exec_popen
      Kernel.exec(@command)
    end

  end # class Popen
end # module Subprocess

