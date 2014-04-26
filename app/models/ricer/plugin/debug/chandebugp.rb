module Ricer::Plugin::Debug
  class Chandebugp < Ricer::Plug::Trigger

    trigger_is :cdbg
    scope_is :user
    
    def execute
      channel = load_channel(argv[0])
      return rplyr :err_channel if channel.nil?
      show(channel)
    end
    
    def show(channel)
      
      rplyp :msg_chaninfo,
        id: channel.id,
        name: channel.displayname,
        server: channel.server.displayname,
        channel: channel
      
    end

  end
end
