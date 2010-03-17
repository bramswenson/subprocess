
module Subprocess
  
  class PopenRemote < Popen
    attr_accessor :hostname, :ssh_params, :command, :pid, :stdout, :stderr, :status

    def initialize(command, hostname, username, *ssh_params)
      @command = command
      @hostname = hostname
      @username = username
      @ssh_params = ssh_params
      @running = false
    end

    private
    def exec_popen
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
    end

  end # class PopenRemote
end # module Subprocess

