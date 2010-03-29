
module Subprocess
  
  class PopenRemote < Popen
    attr_accessor :hostname, :ssh_params

    def initialize(command, hostname, username, *ssh_params)
      @command = command
      @hostname = hostname
      @username = username
      @ssh_params = ssh_params
      @running = false
    end

    private
    def log_to_stderr_and_exit(msg)
      $stderr.write("Net::SSH error: #{@hostname} #{msg}")
      exit 1
    end

    def fork_child_exec
      exit_status = 0
      begin
        ssh = Net::SSH.start(@hostname, @username, *@ssh_params) do |ssh|
          ssh.open_channel do |channel|
            channel.exec(@command) do |chan, success|
              exit 1 unless success

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
      rescue Net::SSH::AuthenticationFailed
        log_to_stderr_and_exit("authentication failure\n")
      rescue Errno::ECONNREFUSED
        log_to_stderr_and_exit("connection refused\n")
      rescue Errno::ETIMEDOUT
        log_to_stderr_and_exit("connection timeout\n")
      rescue Errno::EHOSTUNREACH
        log_to_stderr_and_exit("unreachable\n")
      rescue StandardError => error
        log_to_stderr_and_exit("error: #{error.message}\n")
      rescue
        log_to_stderr_and_exit("unknown error\n")
      end
      exit exit_status
    end

  end # class PopenRemote
end # module Subprocess

