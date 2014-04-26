module Ricer::Plugin::Auth
  class Autologin < Ricer::Plug::Event
    
    def ricer_on_startup
      probe_server
    end
    
    def probe_server
      server.send_raw("PRIVMSG NickServ :STATUS #{server.botnick}")
    end

    def on_privmsg
      if @irc_message.triggered
        do_autologin if should_autologin
      end
    end
    
    # Probably response from Nickserv Status
    def on_notice
      if (user.nickname.downcase == 'nickserv')
        matches = /^STATUS ([^ ]+) ([0-9])$/i.match(argline)
        return if matches.nil?
        username = matches[1]
        status = matches[2]
        if server.botnick.downcase == matches[1]
          server.instance_variable_set('@has_nickserv', true)
          server.instance_variable_set('@has_nickserv_status', true)
        else
          autologin(username)
        end
      end
    end
    
    def on_330
      autologin(args[2])
    end
    
    def autologin(username)
      user = get_user(username)
      unless user.nil?
        user.login!
        server.send_notice(user, t(:msg_logged_in))
      end
    end
    
    def should_autologin
      return false unless user.registered?
      return false if user.authenticated?
      return false if tried_autologin_recently?
      return true
    end
    
    def tried_autologin_recently?
      if !user.instance_variable_defined?('@last_autologin')
        return false
      end
      user.instance_variable_set('@last_autologin', true)
      return true
    end
    
    def do_autologin
      if server.instance_variable_defined?('@has_nickserv_status')
        server.send_privmsg('NickServ', "STATUS #{user.nickname}")
      else
        server.send_raw("WHOIS #{user.nickname}")
      end
    end
    
  end
end
