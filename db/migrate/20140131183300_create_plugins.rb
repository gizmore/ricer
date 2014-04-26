class CreatePlugins < ActiveRecord::Migration
  def change
    create_table :plugins do |t|
      t.string   :name,     :null => false
      t.integer  :revision, :null => false, :default => 0, :unsigned => true
      t.timestamps
    end
  end
end
