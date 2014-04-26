module Ricer::Plugin::Quote
  class Quote < ActiveRecord::Base
    
    acts_as_votable
    
    belongs_to :user
    belongs_to :channel
    
    def self.upgrade_1
      m = ActiveRecord::Migration
      m.create_table :quotes do |t|
        t.integer   :user_id,    :null => false
        t.integer   :channel_id, :null => true
        t.string    :text,       :null => false, :length => 255
        t.datetime  :created_at
      end
      m.add_index :quotes, :text,       name: :quotes_text_index
      m.add_index :quotes, :user_id,    name: :quotes_user_index
      m.add_index :quotes, :channel_id, name: :quotes_channel_index
      m.add_foreign_key :quotes, :users
      m.add_foreign_key :quotes, :channels
    end

  end
end