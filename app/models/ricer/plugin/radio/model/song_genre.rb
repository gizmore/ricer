module Ricer::Plugin::Radio::Model
  class SongGenre < ActiveRecord::Base
    
    self.table_name = 'radio_song_genres'
    
    def self.upgrade_1
      m = ActiveRecord::Migration.new
      m.create_table table_name do |t|
      end
    end
    
  end
end
