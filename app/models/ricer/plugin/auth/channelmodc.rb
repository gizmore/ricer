module Ricer::Plugin::Auth
  class Channelmodc < Ricer::Plug::Trigger
  
    scope_is :channel
    trigger_is :modc
  
    def execute
      case argc
      when 0; execute_modc(channel, user)
      when 1; execute_modc(channel, load_user(argv[0]))
      when 2; execute_modc(channel, load_user(argv[0]), argv[1])
      end
    end
    
    def execute_modc(achan, auser, perm=nil)
      return rplyt 'ricer.err_user' if auser.nil?
      perm == nil ? show_modc(achan, auser) : change_modc(achan, auser, perm)
    end

    private
    
    def show_modc(achan, auser)
      p = auser.chanperms_for(achan)
      rplyp :msg_show_chan,
        user:auser.displayname,
        bitstring:Ricer::Irc::Priviledge.display_bitstring(p.permissions, auser.authenticated?),
        channel:achan.displayname,
        server:server.displayname
    end

    def change_modc(achan, auser, perm)
      
    end
  
  end
end
