module Ricer::Plugin::Radio::Model
  class Show < ActiveRecord::Base
    
    self.table_name = 'radio_shows'
    
    def self.upgrade_1
      m = ActiveRecord::Migration.new
      m.create_table table_name do |t|
      end
    end
    
  end
end
