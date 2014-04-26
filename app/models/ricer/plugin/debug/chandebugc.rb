module Ricer::Plugin::Debug
  class Chandebugc < Ricer::Plug::Trigger
    
    trigger_is :cdbg
    scope_is :channel
    
    def execute
      Chandebugp.new(@irc_message).show(channel)
    end
    
  end
end
