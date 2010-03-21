
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
    def fork_parent_exec
      exit_status = 0
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
      exit exit_status
    end

  end # class PopenRemote
end # module Subprocess

