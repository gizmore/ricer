class AddThrottleToServers < ActiveRecord::Migration
  def change
    add_column :servers, :throttle, :integer, :null => false, :default => 3
  end
end
