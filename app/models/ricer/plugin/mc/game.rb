module Ricer::Plugin::Mc
  class Game < ActiveRecord::Base
    
    self.table_name = :musical_chair_game

    @games = {}
    
    has_many :players

    belongs_to :winner,  :class_name => 'Ricer::Irc::User'
    belongs_to :creator, :class_name => 'Ricer::Irc::User'
    belongs_to :channel, :class_name => 'Ricer::Irc::Channel'
    
    def self.upgrade_1
      m = ActiveRecord::Migration.new
      m.create_table table_name do |t|
        t.integer :winner_id,   :null => true
        t.integer :creator_id,  :null => false
        t.integer :channel_id,  :null => false
        t.string  :song_url,    :null => false
        t.integer :seats_max,   :null => false
        t.integer :seats_taken, :null => false
        t.timestamps
      end
    end

    def self.created_for?(channel)
      @@games[channel] != nil
    end
    
    def self.game_for(channel)
      @@games[channel]
    end
    
  end
end