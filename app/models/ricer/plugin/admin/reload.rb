module Ricer::Plugin::Admin
  class Reload < Ricer::Plug::Trigger

    needs_permission :responsible

    def execute
      rply :msg_reloading
      reload_core
      clear_plugin_class_variables
      bot.rice_up_plugins
      rply :msg_reloaded
    end
    
    protected
    
    def clear_plugin_class_variables
      bot.plugins.each do |plugin|
        plugin.remove_class_variable(:@@TRIGGER)
        plugin.class_variable_set(:@@SETTINGS, {})
        plugin.class_variable_set(:@@EXECUTABLE_EXTENDERS, [])
        plugin.class_variable_set(:@@SUBCOMMANDS, [])
        plugin.remove_class_variable(:@@SUBCOMMAND) if plugin.class_variable_defined?(:@@SUBCOMMAND)
      end
    end
    
    def reload_core
      reload_dir 'app/models/ricer/net'
      reload_dir 'app/models/ricer/irc'
      reload_dir 'app/models/ricer/plug'
    end

    def reload_dir(dirname)
      Dir["#{dirname}/*"].each do |path|
        if File.file?(path)
          if path.end_with?('.rb')
            begin
              load path
            rescue => e
              bot.log_exception(e)
            end
          end
        else
          reload_dir(path)
        end
      end
    end
    
  end
end
