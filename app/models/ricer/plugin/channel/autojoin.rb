module Ricer::Plugin::Channel
  class Autojoin < Ricer::Plug::Event
    
    def on_001
      join = Join.new(@irc_message)
      server.channels.all.each do |channel|
        server.join(channel) if join.autojoins?(channel)
      end
    end
    
  end
end
