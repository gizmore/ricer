class AddSslAndCooldown < ActiveRecord::Migration
  def change

    add_column :servers, :peer_verify,:boolean, :null => false, :default => false
    add_column :servers, :cooldown,   :float,   :null => false, :default => 0.8
    
  end
end
