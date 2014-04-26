module Ricer::Plug::Extender::HasSubcommand
  
  def has_subcommand(name)
    class_eval do |klass|
      
      # Add the subcommand
      subs = klass.class_variable_defined?(:@@SUBCOMMANDS) ? klass.class_variable_get(:@@SUBCOMMANDS) : []
      subcommand = Object.const_get('Ricer').const_get('Plugin').const_get(klass.modulename).const_get(name.to_s.camelize)
      subcommand.class_variable_set(:@@SUBCOMMAND, klass)
      subs.push(subcommand)
      klass.class_variable_set(:@@SUBCOMMANDS, subs)
      
      def execute
        return show_commands if argc == 0
        return show_command_help if argv[0] == help_trigger
        # Sort them, name label could change
        subs = subcommands
        Ricer::Plug::Event.sort_plugins(subs)
        process_trigger_from(subs, true, false)
      end

      def self.init_min_max()
        mmax = 2
        subcommands.each do |plugin|
          plugin.init_argc
          plugin.init_min_max
          max = plugin.maxargs + 1
          mmax = max if max > mmax
        end
        set_min_max(1, mmax)
        bot.log_info "I have set min/max parameter count for #{name} to #{minargs}-#{maxargs}."
      end
      
      protected
      
      def help
        tr('plug.extender.has_subcommand.msg_help', {
          description: description,
          subcommands: subcommand_labels,
        })
      end
      
      def subcommand_labels
        out = [help_trigger]
        subcommands.each do |plugin|
          out.push(plugin.i18n_trigger)
        end
        out.join('|')
      end
  
      private
      
      def help_trigger
        I18n.t 'ricer.plug.extender.has_subcommand.help'
      end
      
      def subcommands
        self.class.subcommands
      end
      
      def self.subcommands
        class_variable_get(:@@SUBCOMMANDS)
      end
      
      def unknown_command_error(command)
        show_help
      end

      def show_commands
        reply 'COMMANDS!'
      end
      
      def show_command_help
        return show_commands if argc == 1
        reply 'HELP!'
      end
      
    end
  end

end
