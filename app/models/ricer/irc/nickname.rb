# create_table "nicknames", force: true do |t|
  # t.integer  "server_id",                                null: false
  # t.integer  "sort_order", default: 0,                   null: false
  # t.string   "nickname",                                 null: false
  # t.string   "hostname",   default: "ricer.gizmore.org", null: false
  # t.string   "username",   default: "Ricer",             null: false
  # t.string   "realname",   default: "Ricer IRC Bot",     null: false
  # t.string   "password"
  # t.datetime "created_at"
  # t.datetime "updated_at"
# end
module Ricer::Irc
  class Nickname < ActiveRecord::Base
    
    scope :sort_ordered, order(:sort_order => :asc)

    belongs_to :server
    validates_presence_of :server
    
   # validates :nickname, :if => :nickname_valid?
    
    after_initialize :nickname_init
    
    def nickname_init
      @cycle ||= ''
    end
    
    
    def self.from_prefix(prefix)
      prefix = prefix.ltrim('!@%+')
      return prefix if prefix[0] != ':'
      index = prefix.index('!')
      return prefix if index.nil?
      prefix[1..index-1]
    end
    
    def nickname_valid?
      self.class.valid?(self.nickname)
    end
    
    def self.valid?(nickname)
      Lib.instance.nickname_valid?(nickname)
    end
    
    def next_nickname
      self.nickname + @cycle
    end
    
    def next_cycle
      @cycle = '_'+SecureRandom.base64(3)
    end
    
    def reset_cycle
      @cycle = '';
    end
    
    def can_authenticate?
      (self.password != nil) && @cycle.empty?
    end
    
  end
end
