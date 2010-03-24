
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
        $stderr.write("Net::SSH error: #{@hostname} authentication failure\n")
      rescue Errno::ECONNREFUSED
        $stderr.write("Net::SSH error: #{@hostname} connection refused\n")
      rescue Errno::ETIMEDOUT
        $stderr.write("Net::SSH error: #{@hostname} connection timeout\n")
      rescue Errno::EHOSTUNREACH
        $stderr.write("Net::SSH error: #{@hostname} unreachable\n")
      rescue
        $stderr.write("Net::SSH error: #{@hostname} unknown error\n")
      end
      exit exit_status
    end

  end # class PopenRemote
end # module Subprocess

