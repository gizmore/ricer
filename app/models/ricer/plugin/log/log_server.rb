module Ricer::Plugin::Log
  class LogServer < Ricer::Plug::Trigger
    
    def self.upgrade_1; Binlog.upgrade_1; end

    scope_is :user
    trigger_is :querylog
    needs_permission :owner
    
    has_setting :enabled, type: :boolean, scope: :channel, permission: :operator, default: true
    has_setting :logtype, type: :enum,    scope: :channel, permission: :owner,    default: :Textlog, enums:[:Binlog, :Textlog]

    def ricer_on_receive
      log(true) if channel.nil? && setting(:enabled)
    end
    
    def ricer_on_send
      log(false) if channel.nil? && setting(:enabled)
    end
    
    def log(input)
#      puts @irc_message.consolestring(input)
      case setting(:logtype)
      when :Binlog; Binlog.irc_message(@irc_message, input)
      when :Textlog; Textlog.irc_message(@irc_message, input)
      end
    end
    
    def execute
      return show if argc == 0
      exec "confs querylog enabled #{argv[0]}"
    end
    
    def show
      rplyp :msg_show_server, server:server.displayname, enabled:get_setting(:enabled, :server)
    end
    
  end
end
