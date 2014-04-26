module Ricer::Plug::Extender::IsSubcommand
  def is_subcommand
    class_eval do |klass|
      
      klass.class_variable_set(:@@SUBCOMMAND, true) unless klass.class_variable_defined?(:@@SUBCOMMAND)

      def self.trigger
        "#{parent_command.trigger} #{super}" 
      end
      
      private

      def parent_command
        self.class.parent_command
      end
      
      def self.parent_command
        class_variable_get(:@@SUBCOMMAND)
      end

      # def self.init_argc
        # class_variable_set(:@@SUBCMDARGC, self.trigger.count(' '))
      # end

    end
  end
end
