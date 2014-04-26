module Ricer::Irc
  class Scope
  
    attr_reader :char, :bit, :name
  
    def initialize(hash)
      hash.each { |name, value| instance_variable_set("@#{name}", value) }
    end
    
    BOT_SCOPE     = 0x8000000
    SERVER_SCOPE  = 0x4000000
    CHANNEL_SCOPE = 0x2000000
    USER_SCOPE    = 0x1000000
    BOTH_SCOPES   = CHANNEL_SCOPE|USER_SCOPE
    ALL_SCOPES    = 0xF000000
  
    @@all = 
    {
      # Trigger scopes
      user:       new(char:'u', bit:USER_SCOPE,    :name => :user),
      channel:    new(char:'c', bit:CHANNEL_SCOPE, :name => :channel),
      everywhere: new(char:'e', bit:BOTH_SCOPES,   :name => :everywhere),
      # Additional Setting scopes
      bot:        new(char:'b', bit:BOT_SCOPE,     :name => :bot),    # For settings only
      server:     new(char:'s', bit:SERVER_SCOPE,  :name => :server), # For settings only
      all:        new(char:'a', bit:ALL_SCOPES,    :name => :all),    # For settings only
    }
    
    def self.valid?(name)
      self.by_name(name) != nil 
    end
    
    def self.by_name(name)
      @@all[name.to_sym]
    end
    
    def self.matching?(scope, scopes, channel)
      bit = self.by_name(scope).bit
      Array(scopes).each do |sa|
        if (sa.to_sym != :channel && scope.to_sym != :channel) || (channel != nil)
          return true if (self.by_name(sa).bit & bit) > 0
        end
      end
      return false
    end
    
    def to_label
      I18n.t('ricer.irc.scope.'+self.char)
    end
      
    def self.to_label(name)
      self.by_name(name).to_label
    end

  end
end
