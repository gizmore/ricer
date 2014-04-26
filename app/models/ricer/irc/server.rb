# t.string   "url",                                               null: false
# t.string   "connector",   default: "Ricer::Net::Irc",           null: false
# t.string   "triggers",    default: ".",                         null: false
# t.boolean  "enabled",     default: true,                        null: false
# t.datetime "created_at"
# t.datetime "updated_at"
# t.integer  "throttle",    default: 3,                           null: false
# t.boolean  "peer_verify", default: false,                       null: false
# t.float    "cooldown",    default: 0.8,                         null: false
module Ricer::Irc
  class Server < ActiveRecord::Base
    
    with_global_orm_mapping
    
    attr_reader   :connection, :joined_channels, :connected_users, :processor, :current_nickname
    attr_accessor :botnick, :ricer
  
    has_many :users #, :class => Ricer::Irc::User
    has_many :channels
    has_many :nicknames

    scope :enabled, where(:enabled => 1)
    scope :disabled, where(:enabled => 0)
    scope :in_domain, lambda { |url| where('servers.url LIKE ?', "%.#{self.domain(url)}:%") }
    
    def bot; Ricer::Bot.instance; end

    def displayname; return id.to_s+'-'+hostname; end
    
    def uri; URI(url); end
    def ssl?; uri.scheme == 'ircs'; end
    def hostname; uri.host; end
    def port; uri.port; end
    def domain; self.class.domain(hostname); end
    def self.domain(s); s.split('.')[-2,2].join('.'); end
    
    def started_up?
      @conn_once || (@conn_attempt >= 4)
    end
    
    def fresh_cache
      @last_connect = Time.now.to_f
      @conn_attempt = 1
      @conn_once = false
      @processor = Processor.new(self)
      @connection = connection_object
      @nicknames = nicknames.all
      @nickname_enum = @nicknames.each
      @current_nickname = @nickname_enum.peek
      @connected_users = {}
      @joined_channels = {}
    end
    
    
    def connector_module
      # TODO: also stuff0and1 needed!
      stuff = self.connector.split('::')
      Ricer::Net.const_get(stuff[2])
    end
    
    def connection_class; connector_module.const_get(:Connection); end
    def connection_object; connection_class.new(self); end
    def message_class; connector_module.const_get(:Message); end
    def message_object(line=nil); message_class.new(line); end
    
    def is_triggered?(trigger)
      self.triggers.index(trigger) != nil
    end
    
    def get_user(prefix)
      @connected_users[Nickname.from_prefix(prefix).downcase]
    end
    
    def load_user(prefix)
      nickname = Nickname.from_prefix(prefix)
      user = users.where(:nickname => nickname).first
      if user != nil
        @connected_users[nickname.downcase] = user
        user.joined_server(self)
      end
      user
    end

    def create_user(prefix)
      user = get_user prefix
      user = load_user prefix if user.nil?
      if user.nil?
        nickname = Nickname.from_prefix(prefix)
        nn = nickname.downcase
        user = @connected_users[nn] = users.create!({nickname:nickname})
        user.joined_server(self)
      end
      user
    end
    
    def user_parted(user)
      nn = user.nickname.downcase
      @connected_users.delete nn
      @joined_channels.each do |k,c|
        c.user_parted user
      end
    end
    
    def get_channel(name)
      @joined_channels[name.downcase]
    end

    def create_channel(name)
      channel = get_channel name
      if channel.nil?
        channel = @joined_channels[name.downcase] = channels.where(name:name).first
        channel = @joined_channels[name.downcase] = channels.create!(name:name) if channel.nil?
        channel.connect
      end
      channel
    end
    
    def joined_channel?(channel)
      get_channel(channel.name) != nil
    end
    
    def should_cache?; true; end
    
    def startup
      bot.log_info("Enterting mainloop for #{hostname}")
      fresh_cache
      while bot.running
        if cooldown?
          sleep 2
        elsif !@connection.connected?
          @conn_attempt += 1
          @last_connect = Time.now.to_f
          @connection.connect
          login
        else
          bot.failed = false
          process_message @connection.get_message
        end
      end
    end
    
    def login_success
      @conn_once = true
      @conn_attempt = 1
    end
    def cooldown?
      ([@conn_attempt ** 1.61, 15.minutes].min + @last_connect.to_f) > Time.now.to_f
    end
    
    def login
      @connection.login(@current_nickname)
    end
    def send_nick
      @connection.send_nick(@current_nickname)
    end
    def send_pong(ping)
      @connection.send_pong(ping)
    end
   
    def connected?
      @connection == nil ? false : @connection.connected?
    end
    
    def disconnect
      @connection.disconnect unless @connection.nil?
    end
    
    def next_nickname
      begin
        @current_nickname = @nickname_enum.next
      rescue => e
        @nickname_enum.rewind
        @current_nickname = @nickname_enum.peek
      end
    end
    
    def nick_fail
      @nickname_enum.peek.next_cycle && next_nickname
    end
    
    def process_message(irc_message)
      if !irc_message.nil?
        bot.failed = false
        @processor.process(irc_message)
      end
    end
    
    def fake_message_string(from, to, message, type='PRIVMSG')
      "#{from.get_prefix} #{type} #{to.nickname} :#{message}"
    end
    
    def ricer_on(eventname, irc_message)
      @processor.process_event("ricer_on_#{eventname}", irc_message)
    end
    
    def on(eventname, irc_message, args=nil)
      @processor.process_event("on_#{eventname}", irc_message)
    end
    
    def ricer_sends(to, line)
      irc_message = message_object(line)
      irc_message.server = self
      irc_message.user = to if to.class < User
      irc_message.channel = to if to.class < Channel
      puts irc_message.consolestring(false)
      ricer_on('send', irc_message)
    end
    
    def join(channel); send_join(channel.name); end
    def part(channel); send_part(channel.name); end

    def send_raw(message); @connection.send_raw message; end
    
    def send_notice(to, message, prefix=''); @connection.send_notice to, message, prefix; end
    def send_privmsg(to, message, prefix=''); @connection.send_privmsg to, message, prefix; end
    def send_join(channelname); @connection.send_join channelname; end
    def send_part(channelname); @connection.send_part channelname; end
    def send_quit(quitmessage); @connection.send_quit quitmessage; end
 
  end
end
