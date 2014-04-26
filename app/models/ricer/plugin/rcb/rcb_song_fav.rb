module Ricer::Plugin::Rcb
  class RcbSongFav < ActiveRecord::Base
    
    belongs_to :user, :class_name => 'Ricer::Irc::User'
    belongs_to :rcb_song, counter_cache: :favcount
    
    def self.upgrade_1
      m = ActiveRecord::Migration.new
      m.create_table :rcb_song_favs do |t|
        t.integer :rcb_song_id, :null => false
        t.integer :user_id,     :null => false
        t.integer :level,       :null => false, :default => 0
        t.timestamps
      end
      m.add_index :rcb_song_favs, :user_id, :name => :rcb_songfav_user_index
      m.add_foreign_key :rcb_song_favs, :users,     :dependent => :delete
      m.add_foreign_key :rcb_song_favs, :rcb_songs, :dependent => :delete
    end
    
    def self.for_user(user)
      where(:user => user)
    end
    
    def self.favorize(user, song)
      entry = where(user:user, rcb_song:song).first
      entry = new({user:user, rcb_song:song}) if entry.nil?
      entry.level = entry.level + 1
      entry.save!
      entry
    end
    
  end
end
