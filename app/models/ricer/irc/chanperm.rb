# t.integer :user_id, :null => false
# t.integer :channel_id, :null => false
# t.integer :permissions, :default => 0
# t.timestamps
module Ricer::Irc
  class Chanperm < ActiveRecord::Base
    
    belongs_to :user
    belongs_to :channel
    
    attr_reader :usermode
    
    after_initialize :init
    
    def init
      @usermode = Mode::Usermode.new
    end
    
    def db_permissions
      self.permissions
    end
    
    def chan_permissions
      @usermode.permissions
    end
    
    def best_permissions
      [@usermode.permissions, self.permissions].max
    end
    
    def display_permissions
      @usermode.display_permissions
    end
    
  end
end
