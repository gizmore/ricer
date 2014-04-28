module Ricer::Plugin::Channel
  class Partu < Ricer::Plug::Trigger
    
    scope_is :user
    needs_permission
  
    def execute
      part(argv[0])
    end
    
    def part(channelname)

      channel = load_channel(channelname)
      return rplyr :err_channel if channel.nil?
      
#      if has_permission_in?(channel, :operator)
        # Turn autojoin off
        join = Join.new(@irc_message)
        if join.autojoins? channel
          join.set_autojoin channel, false
          rplyp :msg_autojoin_off, channel
        end
        
        # And part
        if server.joined_channel? channel.name
          server.part channel
        end
      end

 #   end
    
  end
end
