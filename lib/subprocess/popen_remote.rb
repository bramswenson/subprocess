
module Subprocess
  
  class PopenRemote
    attr_accessor :hostname, :ssh_params, :command, :pid, :stdout, :stderr, :status

    def initialize(command, hostname, username, *ssh_params)
      @command = command
      @hostname = hostname
      @username = username
      @ssh_params = ssh_params
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
        
        exit_status = 0
        ssh = Net::SSH.start(@hostname, @username, *@ssh_params) do |ssh|
          ssh.open_channel do |channel|
            channel.exec(@command) do |chan, success|
              #unless success exit 1

              channel.on_data do |chan, data|
                $stdout.write data
              end

              channel.on_extended_data do |chan, type, data|
                $stderr.write data
              end

              channel.on_request('exit-status') do |chan, data|
                exit_status = data.read_long.to_i
              end

            end
          end
          ssh.loop
        end
        exit exit_status
      }
      stdin_rd.close
      stdout_wr.close
      stderr_wr.close
      stdin_wr.sync = true
    end

    def wait
      @pid, @status = Process.wait2(@pid)
      @running = false
      @stdout, @stderr = @stdout_rd.read.chomp, @stderr_rd.read.chomp
      @stdout_rd.close; @stderr_rd.close
    end

  end # class Popen
end # module Subprocess

