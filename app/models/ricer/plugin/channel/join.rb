module Ricer::Plugin::Channel
  class Join < Ricer::Plug::Trigger
    
    needs_permission :halfop
    
    has_setting :auto,   type: :boolean, scope: :channel, permission: :halfop,   default: true
    has_setting :onkick, type: :boolean, scope: :channel, permission: :operator, default: false
    
    def set_autojoin(channel, boolean)
      channel_setting(channel, :auto, boolean)
    end
    
    def autojoins?(channel)
      channel_setting(channel, :auto)
    end

    def execute
      channelname = argv[0]
      return rplyr :err_channel_name unless Ricer::Irc::Channel.name_valid?(channelname)
      return rply  :err_already_there if server.joined_channel?(channelname)
      rply :msg_trying_to_join
      @@join_issuers[channelname] = user
      server.send_join channelname
    end
    
    def on_join
      auser = issuer(channel.name)
      auser.init_chanperms(channel, :owner) unless auser.nil?
    end
    
    private
    @@join_issuers = {}
    def issuer(channelname)
      issuer = @@join_issuers[channelname]
      @@join_issuers.delete(channelname) unless issuer.nil?
      return issuer
    end
      
  end
end
