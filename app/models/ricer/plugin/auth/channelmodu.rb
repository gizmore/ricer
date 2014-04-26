module Ricer::Plugin::Auth
  class Channelmodu < Ricer::Plug::Trigger
  
    scope_is :user
    trigger_is :modc
  
    def execute
      channel = load_channel(argv[0])
      return rplyr :err_channel if channel.nil?
      plug = Channelmodc.new(@irc_message)
      case argc
      when 1; plug.execute_modc(channel, user)
      when 2; plug.execute_modc(channel, load_user(argv[1]))
      when 3; plug.execute_modc(channel, load_user(argv[1]), argv[2])
      end
    end
    
  end
end
