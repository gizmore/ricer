module Ricer::Plugin::Ricer
  class Connection <  Ricer::Plug::CoreEvent
    
    def on_error
      server.disconnect
    end

    def on_ping
      server.send_pong(args[0])
    end
    
    def on_001
      server.login_success
      if server.instance_variable_defined?('@added_by')
        added_by = server.remove_instance_variable('@added_by')
      end
    end

     def on_002
      Ricer::Irc::Mode::Mode.init_signature(@irc_message.line)
    end
    
    #  :gizmore!e@localhost MODE #sr +o Peter
    def on_mode
      @irc_message.channel = channel = server.get_channel(@irc_message.args[0])
      if (channel.nil?)
        user = server.get_user(args[0])
        change_usermode(user) unless user.nil?
      else
        change_channelmode(channel)
      end
    end
    
    def change_usermode(user)
      sign = args[1][0]
      modes = args[1][1..-1]
    end

    def change_channelmode(channel)
      sign = args[1][0]
      modes = args[1][1..-1]
      count = 2
      modes.chars.each do |mode|
        if Ricer::Irc::Mode::Chanmode.knows?(mode)
          sign == '+' ? channel.chanmode.add_mode(mode) : channel.chanmode.remove_mode(mode)
        elsif Ricer::Irc::Mode::Usermode.knows?(mode)
          user = load_user(args[count])
          sign == '+' ?
            user.chanperms_for(channel).usermode.add_mode(mode) :
            user.chanperms_for(channel).usermode.remove_mode(mode)
        end
      end
    end
    
    def on_join
      @irc_message.user = server.create_user(@irc_message.prefix)
      @irc_message.channel = channel = server.create_channel(args[0])
      channel.user_joined(@irc_message.user)
    end

    # def on_part
      # @irc_message.user = server.create_user(@irc_message.prefix)
      # @irc_message.channel = channel = server.create_channel(args[0])
      # channel.user_joined(@irc_message.user)
    # end
    
    def on_nick
      olduser = server.create_user(@irc_message.prefix)
      newnick = args[0]
      newuser = server.create_user(newnick)
      if olduser != nil
        olduser.joined_channels.each do |channelname, channel|
          channel.user_joined(newuser)
        end
        server.user_parted(olduser)
      end
    end
    
    def on_433
      server.nick_fail
      server.send_nick
    end

    def on_353
      @irc_message.channel = channel = server.create_channel(args[2])
      args[3].split(' ').each do |username|
        user = server.create_user(username)
        channel.user_joined(user)
        perms = user.chanperms_for(channel)
        perms.usermode.init_from_username(username)
      end
    end
    
  end
end
