module Subprocess
  module PopenFactoryMixin

    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods

      def def_command(name, command, klass_type=Subprocess::PopenRemote)
        instance_eval "
          def self.#{name}(*args)
            #{klass_type.name}.new('#{command}', *args)
          end
        ", __FILE__, __LINE__
      end
      
      def def_command_template(name, command, klass_type=Subprocess::PopenRemote)
        instance_eval "
          def self.#{name}(data, *args)
            command = lambda do |data|
              \"#{command}\"
            end
            #{klass_type.name}.new(command.call(data), *args)
          end
        ", __FILE__, __LINE__
      end
    
    end # ClassMethods
  end # PopenFactoryMixin
end # Subprocess

