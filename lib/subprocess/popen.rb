
module Subprocess
  
  class Popen
    attr_accessor :command, :pid, :stdout, :stderr, :status

    def initialize(command)
      @command = command
      @running = false
    end

    def is_running?
      @running
    end

    def run
      # heavly influenced by open3.popen3
      # http://ruby-doc.org/stdlib/libdoc/open3/rdoc/index.html
      stdin_rd, stdin_wr = IO::pipe
      @stdout_rd, stdout_wr = IO::pipe
      @stderr_rd, stderr_wr = IO::pipe
      @running = true
      @start_time = Time.now.to_f
      @pid = Kernel.fork {
        # redirect the forks std streams into pipes
        stdin_wr.close
        STDIN.reopen(stdin_rd)
        stdin_rd.close

        @stdout_rd.close
        STDOUT.reopen(stdout_wr)
        stdout_wr.close

        @stderr_rd.close
        STDERR.reopen(stderr_wr)
        stderr_wr.close

        Kernel.exec(@command)
      }
      stdin_rd.close
      stdout_wr.close
      stderr_wr.close
      stdin_wr.sync = true
    end

    def wait
      @pid, @status = Process.wait2(@pid)
      @exitcode = @status.exitstatus
      @running = false
      @stdout, @stderr = @stdout_rd.read.chomp, @stderr_rd.read.chomp
      @stdout_rd.close; @stderr_rd.close
    end

  end # class Popen
end # module Subprocess

