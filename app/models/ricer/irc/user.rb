# t.integer  "server_id",                     null: false
# t.integer  "permissions",     default: 0,   null: false
# t.string   "nickname",                      null: false
# t.string   "hashed_password"
# t.string   "email"
# t.string   "message_type",    default: "n", null: false
# t.string   "gender",          default: "m", null: false
# t.integer  "locale_id",       default: 1,   null: false
# t.integer  "encoding_id",     default: 1,   null: false
# t.integer  "timezone_id",     default: 1,   null: false
# t.datetime "created_at"
# t.datetime "updated_at"
module Ricer::Irc
  class User < ActiveRecord::Base
    
    require 'bcrypt'
    
    with_global_orm_mapping
    
    attr_reader :joined_channels, :usermode, :prefix
    
    belongs_to :server
    belongs_to :locale
    belongs_to :timezone
    belongs_to :encoding
    has_many   :chanperms
    
    validates_as_email :email, allow_nil: true
    
    def localize!
      I18n.locale = self.locale.iso
      Time.zone = self.timezone.iso
      self
    end

    def should_cache?; @connected == true; end
    def send_notice(message); server.send_notice(self, message) if @connected; end
    def send_privmsg(message); server.send_privmsg(self, message) if @connected; end
    
    def authenticated?
      @authenticated ? true : false
    end
    
    def registered?
      self.hashed_password != nil
    end
    
    def displayname
      Lib.instance.no_highlight(nickname)
    end
    
    def name
      nickname
    end
    
    def display_permissions
      Ricer::Irc::Priviledge.bitstring(self.permissions)
    end
    
    def chanperms_for(channel)
      if @chanperms[channel.id].nil?
        back = chanperms.where(channel_id:channel.id).first
        back = chanperms.create!(channel_id:channel.id) if back.nil?
        @chanperms[channel.id] = back
      end
      @chanperms[channel.id]
    end
    
    def set_prefix(prefix)
      if prefix.index('!') != nil?
        if prefix != @prefix
          @authenticated = false 
          @prefix = prefix
        end
      end
    end
    
    def init_chanperms(channel, priv)
      perms = chanperms_for(channel)
      perms.permissions = Priviledge.by_name(priv).bits
      perms.save!
      perms
    end

    # Get privbits for a scope    
    def privbits(channel=nil, effective=true)
      if channel == nil
        # Query == server permissions
        bits = self.permissions
      else
        # Channel bits db and mode in chan
        perms = chanperms_for(channel)
        db = perms.db_permissions
        ch = perms.chan_permissions
        if effective == false
          bits = db # Non Effective means we probably wanna show db settings
        elsif ch >= db || !authenticated?
          bits = ch # Channel is better, so skip the effective check below!
          effective = false
        else
          bits = db # Normal db setting
        end
      end
      bits = Ricer::Irc::Priviledge.not_authenticated(bits) if effective && !authenticated?
      bits
    end
  
    def authenticate!(password)
      return @authenticated = false unless registered?
      @authenticated = BCrypt::Password.new(self.hashed_password).is_password?(password)
    end
    
    def login!
      @authenticated = true
    end
    def logout!
      @authenticated = false
    end
    
    def password=(new_password)
      first_time = !self.registered?
      self.hashed_password = BCrypt::Password.create(new_password)
      self.save!
      register if first_time
    end
  
    def joined_server(server)
      @usermode = Mode::Usermode.new
      flush_chanperms
      @authenticated = false
      @joined_channels = {}
      connect
    end
    
    def connect
      @connected = true
      global_cache_table(self)
    end

    def parted_server(server)
      @connected = false
    end

    def joined_channel(channel)
      @joined_channels[channel] = channel
      create_chanperms(channel)
    end
    
    def create_chanperms(channel)
      chanperms_for(channel)
    end

    def parted_channel(channel)
      @joined_channels.delete(channel)
    end
    
    def flush_chanperms
      @chanperms = {}
    end
    
    private
    def register
      self.permissions |= Priviledge::REGISTERED|Priviledge::AUTHENTICATED
      self.save!
      flush_chanperms
      chanperms.all.each do |m|
        m.permissions |= Priviledge::REGISTERED|Priviledge::AUTHENTICATED
        m.save!
      end
      self.save!
    end
    
  end
end
