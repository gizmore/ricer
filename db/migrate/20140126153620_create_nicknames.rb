class CreateNicknames < ActiveRecord::Migration
  def change
    create_table :nicknames do |t|
      
      t.integer :server_id, :null => false
      t.integer :sort_order, :default => 0, :null => false
      t.string  :nickname, :null => false, :length => 64
      t.string  :hostname, :null => false, :default => 'ricer.gizmore.org'
      t.string  :username, :null => false, :default => 'Ricer'
      t.string  :realname, :null => false, :default => 'Ricer IRC Bot'
      t.string  :password

      t.timestamps
    end
  end
end
