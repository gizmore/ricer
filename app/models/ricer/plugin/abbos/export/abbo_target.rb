module Ricer::Plugin::Abbos
  class AbboTarget < ActiveRecord::Base
    
    belongs_to :target, :polymorphic => true
    
    def self.upgrade_1
      m = ActiveRecord::Migration.new
      m.create_table table_name do |t|
        t.integer :target_id,   :null => false
        t.string  :target_type, :null => false
      end
    end
    
    def self.for(target)
      where({target:target}).first || create({target:target})
    end
    
  end
end