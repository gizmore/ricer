module Ricer::Plugin::Radio::Model
  class Played < ActiveRecord::Base
    
    self.table_name = 'radio_songs_played'
    
    def self.upgrade_1
      m = ActiveRecord::Migration.new
      m.create_table table_name do |t|
      end
    end
    
  end
end
