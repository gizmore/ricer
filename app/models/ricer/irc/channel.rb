# create_table :channels do |t|
  # t.integer :server_id
  # t.string  :name
  # t.string  :triggers,    :default => '.', :null => false, :length => 4
  # t.integer :locale_id,   :default => 1,   :null => false
  # t.integer :timezone_id, :default => 1,   :null => false
  # t.integer :encoding_id, :default => 1,   :null => false
  # t.boolean :colors,      :default => true
  # t.boolean :decorations, :default => true
  # t.timestamps
# end
module Ricer::Irc
  class Channel < ActiveRecord::Base
    
    with_global_orm_mapping    
    
    belongs_to :server
    belongs_to :locale
    belongs_to :timezone
    belongs_to :encoding
    
    attr_reader :chanmode, :users
    
    def displayname; self.name; end
    
    def self.name_valid?(channelname)
      Lib.instance.channelname_valid?(channelname)
    end
    
    def is_triggered?(trigger)
      self.triggers.index(trigger) != nil
    end
    
    def user_joined(user)
      @users[user] = user
      user.joined_channel(self)
    end
  
    def user_parted(user)
      @users.delete(user)
      user.parted_channel(self)
    end

    def localize!
      I18n.locale = self.locale.iso
      Time.zone = self.timezone.iso
      self
    end
    
    def connect
      @users ||= {}
      @chanmode ||= Mode::Chanmode.new
      @connected = true
      global_cache_table(self)
    end
    
    def should_cache?; @connected == true; end
    def send_notice(message); server.send_notice(self, message) if @connected; end
    def send_privmsg(message); server.send_privmsg(self, message) if @connected; end
    
  end
end
