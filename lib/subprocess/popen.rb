
module Subprocess
  
  class Popen
    attr_accessor :command, :pid, :stdin, :stdout, :stderr, :exitcode, 
      :start_time, :end_time

    def initialize(command)
      @command = command
    end

    def run
      # taken almost line for line from open3's popen3
      # http://ruby-doc.org/stdlib/libdoc/open3/rdoc/index.html
      pw = IO::pipe   # pipe[0] for read, pipe[1] for write
      pr = IO::pipe
      pe = IO::pipe

      @pid = fork{
        pw[1].close
        STDIN.reopen(pw[0])
        pw[0].close

        pr[0].close
        STDOUT.reopen(pr[1])
        pr[1].close

        pe[0].close
        STDERR.reopen(pe[1])
        pe[1].close

        exec(command)
      }

      pw[0].close
      pr[1].close
      pe[1].close
      @start_time = Time.now
      @exitcode = Process.wait2(@pid)[1].exitstatus
      @end_time = Time.now
      pw[1].sync = true
      @stdin, @stdout, @stderr = pw[1], pr[0].read.chomp, pe[0].read.chomp
      pi = [ @stdin, @stdout, @stderr ]
      if defined? yield
        begin
          return yield(*pi)
        ensure
          pi.each{|p| p.close unless p.closed?}
        end
      end
      @exitcode
    end

  end # class Popen
end # module Subprocess

