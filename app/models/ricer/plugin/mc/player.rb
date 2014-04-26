module Ricer::Plugin::Mc
  class Player < ActiveRecord::Base
    
    self.table_name = :musical_chair_participants
    
    belongs_to :game, :class_name => 'Ricer::Plugin::Mc::Game'
    belongs_to :user, :class_name => 'Ricer::Irc::User'
    
    def self.upgrade_1
      m = ActiveRecord::Migration.new
      m.create_table table_name do |t|
        t.integer :game_id, :null => false
        t.integer :user_id, :null => false
        t.timestamps
      end
    end
    
  end
end