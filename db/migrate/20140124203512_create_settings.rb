class CreateSettings < ActiveRecord::Migration
  def up
    drop_table :settings if table_exists? :settings
    create_table :settings, { :id => false } do |t|
      t.string  :id,    :null => false, :length => 128 # server|4|foo
      t.string  :value, :null => false
      t.timestamps
    end
    execute "ALTER TABLE settings ADD PRIMARY KEY (id);"
  end
  def down
    drop_table :settings
  end
end
