require 'erb'

module Subprocess
  module PopenFactoryMixin

    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods

      def def_command(name, command, class_meths=true)
        name = class_meths ? "self.#{name}" : name
        instance_eval "
          def #{name}(*args)
            Subprocess::Popen.new('#{command}', *args)
          end
        ", __FILE__, __LINE__
      end
      
      def def_dynamic_command(name, command, class_meths=true)
        name = class_meths ? "self.#{name}" : name
        instance_eval "
          def #{name}(data, *args)
            command = lambda do |data|
              \"#{command}\"
            end
            Subprocess::Popen.new(command.call(data), *args)
          end
        ", __FILE__, __LINE__
      end
    end # ClassMethods
  end # PopenFactoryMixin

  module PopenRemoteFactoryMixin

    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods

      def def_command(name, command, hostname_var, username_var, ssh_params_var, timeout=300)
        instance_eval do 
          define_method name.to_sym do
            eval("Subprocess::PopenRemote.new('#{command}', #{hostname_var}, #{username_var}, timeout, *#{ssh_params_var})")
          end
        end
      end

      def def_dynamic_command(name, command, hostname_var, username_var, ssh_params_var, timeout=300)
        instance_eval do 
          define_method name.to_sym do |data|
            cmd = ERB.new(command).result(binding)
            eval("Subprocess::PopenRemote.new(cmd, #{hostname_var}, #{username_var}, timeout, *#{ssh_params_var})")
          end
        end
      end
    end # ClassMethods
  end # PopenRemoteFactoryMixin

end # Subprocess

