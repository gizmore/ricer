class CreateChanperms < ActiveRecord::Migration
  def change
    create_table :chanperms do |t|
      t.integer :user_id, :null => false
      t.integer :channel_id, :null => false
      t.integer :permissions, :default => 0
      t.timestamps
    end
  end
end
