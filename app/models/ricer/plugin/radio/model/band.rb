module Ricer::Plugin::Radio::Model
  class Band < ActiveRecord::Base
    
    self.table_name = 'radio_bands'
    
    def self.upgrade_1
      m = ActiveRecord::Migration.new
      m.create_table table_name do |t|
      end
    end
    
  end
end
