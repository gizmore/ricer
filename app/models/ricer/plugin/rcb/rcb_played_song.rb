module Ricer::Plugin::Rcb
  class RcbPlayedSong < ActiveRecord::Base
    
    belongs_to :rcb_song, counter_cache: :playcount
    
    def self.upgrade_1
      m = ActiveRecord::Migration.new
      m.create_table :rcb_played_songs do |t|
        t.integer  :rcb_song_id,   :null => false
        t.datetime :played_at, :null => false
      end
      m.add_foreign_key :rcb_played_songs, :rcb_songs, :dependent => :delete
    end
    
    def self.now_playing(rcb_song)
      create({
        rcb_song: rcb_song,
        played_at: Time.now,
      })
    end
    
  end
end
