module Ricer::Irc
  class Processor
    
    def initialize(server)
      @server = server
    end
    
    def process(irc_message)
      irc_message.server = @server
      process_event "on_#{irc_message.command}", irc_message
      process_event "ricer_on_receive", irc_message
    end
    
    def process_event(methodname, irc_message)
      bot = Ricer::Bot.instance
      bot.plugins.each do |p|
        if p.method_defined?(methodname)
          eventobject = p.new(irc_message)
          eventobject.process_event(methodname)
        end
      end
    end

  end
end
