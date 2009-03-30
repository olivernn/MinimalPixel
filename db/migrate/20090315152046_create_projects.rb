class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.integer :user_id, :null => false
      t.string  :name, :null => false, :limit => 100
      t.text    :description, :null => true
      t.date    :date, :null => true
      t.string  :status, :null => false   
      t.timestamps
    end
    
    add_index :projects, :name
    add_index :projects, :status
    add_index :projects, :user_id
  end

  def self.down
    drop_table :projects
  end
end
