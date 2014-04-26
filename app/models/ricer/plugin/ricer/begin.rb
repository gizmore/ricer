module Ricer::Plugin::Ricer
  class Begin < Ricer::Plug::Trigger
    
    def self.priority; 2; end
    
    def on_privmsg
      if @irc_message.triggered
        remove_line
      elsif has_line?
        append_line
      end
    end
    
    def has_line?; user.instance_variable_defined?(:@multiline_command); end
    def get_line; user.instance_variable_get(:@multiline_command); end
    def set_line(line); user.instance_variable_set(:@multiline_command, line); end
    def remove_line; user.remove_instance_variable(:@multiline_command) if has_line? end
    def append_line; set_line(get_line + argline); end
    
    def execute
      plugin = classobject_by_arg(argv[0])
      return rplyr :err_plugin if plugin.nil?
      line = argline
      line = line.substr_to(' ') || line
      set_line(line+' ')
    end
    
    def finish
      return rply :err_no_begin unless has_line?
      line = get_line
      remove_line
      exec(line)
    end

  end
end
