module Ricer::Plugin::Log
  class LogChannel < Ricer::Plug::Trigger
    
    scope_is :channel
    trigger_is :log
    needs_permission :operator
    
    has_setting :enabled, type: :boolean, scope: :channel, permission: :operator, default: true
    has_setting :logtype, type: :enum,    scope: :channel, permission: :owner,    default: :Textlog, enums:[:Binlog, :Textlog]

    def ricer_on_receive
      log(true) if channel && setting(:enabled)
    end
    
    def ricer_on_send
      log(false) if channel && setting(:enabled)
    end
    
    def log(input)
      #puts @irc_message.consolestring(input)
      case setting(:logtype)
      when :Binlog; Binlog.irc_message(@irc_message, input)
      when :Textlog; Textlog.irc_message(@irc_message, input)
      end
    end
    
    def execute
      return show if argc == 0
      exec "confc log enabled #{argv[0]}"
    end
    
    def show
      rplyp :msg_show_channel, channel:channel.displayname, enabled:show_setting(:enabled, :channel)
    end
    
  end
end
