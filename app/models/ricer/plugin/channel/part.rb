module Ricer::Plugin::Channel
  class Part < Ricer::Plug::Trigger
    
    scope_is :channel
    needs_permission :halfop
  
    def execute
      plug = Partu.new(@irc_message)
      argc == 1 ?
        plug.part(argv[0]) :
        plug.part(channel.name)
    end
    
  end
end
