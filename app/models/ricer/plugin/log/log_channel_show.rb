module Ricer::Plugin::Log
  class LogChannelShow < Ricer::Plug::Trigger
    
    scope_is :channel
    trigger_is :log

    def execute
      LogChannel.new(@irc_message).show
    end
    
  end
end
