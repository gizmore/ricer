module Ricer::Plug
  class PlugBase < Command

    def self.plugin_id; class_variable_get(:@@PLUGID); end
    def plugin_id; self.class.plugin_id; end

    def self.plugin_path; class_variable_get(:@@PLUGPATH); end
    def self.plugin_dir; file = plugin_path; file[0..file.rindex('/')]; end
    def self.lang_dir; plugin_dir + 'lang/'; end
    def self.install_dir; plugin_dir + 'install/'; end
    
    # Create a user if necessary and load into cache.
    # Also setup locales
    def create_user(arg=nil)
      if arg.nil?
        @irc_message.user = server.create_user(@irc_message.prefix)
        @irc_message.user.set_prefix(@irc_message.prefix)
      else
        @irc_message.user = server.create_user(arg)
      end
      @irc_message.user.localize!
    end
    
    def rand(arg)
      bot.rand.rand(arg)
    end
    
    def load_server(arg)
      server = Ricer::Irc::Server.where(:id => arg).first
      if server.nil?
        servers = Ricer::Irc::Server.in_domain(arg)
        server = servers.first if servers.count == 1
      end
      server
    end
    
    # Load a user, maybe from cache, but don´t put into cache
    def load_user(arg)
      # puts "PlugBase::load_user(#{arg})"
      sid = arg.substr_from('!')
      nick = arg.substr_to('!') || arg
      serv = server if sid.nil?
#      serv = Ricer::Bot.instance.get_server(sid) if serv.nil?
      serv = Server.where(:id => sid) if serv.nil?
      # puts serv
      user = serv.get_user(nick) unless serv.nil?
      user = serv.users.where(:nickname => nick).first if user.nil? && serv != nil
      return user
    end
    
    # Get a user from cache
    def get_user(arg)
      sid = arg.substr_from('!')
      nick = arg.substr_to('!') || arg
      serv = server if sid.nil?
      serv = Server.where(:id => sid) if serv.nil?
      user = serv.get_user(nick) unless serv.nil?
      user
    end
    
    # Load a channel, maybe from cache, but don´t put into cache
    def load_channel(arg)
      chan = server.get_channel(arg)
      chan = server.channels.where(:name => arg).first if chan.nil?
      return chan
    end

     # Get a channel from cache
    def get_channel(arg)
      server.get_channel(arg)
    end

    def generic_mail(to, subject, body)
      Thread.new do |t|
        BotMailer.generic(to, subject, body).deliver
      end
    end

  end
end
