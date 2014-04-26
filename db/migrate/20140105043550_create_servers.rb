class CreateServers < ActiveRecord::Migration
  def change
    create_table :servers do |t|
      t.string  :url,         :null => false
      t.string  :connector,   :default => 'Ricer::Net::Irc',  :null => false
      t.string  :triggers,    :default => ',', :null => false, :length => 4
      t.boolean :enabled,     :default =>  1,  :null => false
      t.timestamps
    end
    
    create_table :server_urls do |t|
      t.integer :server_id, :null => false
      t.string  :url, :null => false
      t.string  :ip, :length => 43
      t.timestamps
    end
    
  end
end
