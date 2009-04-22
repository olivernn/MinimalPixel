class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.integer :user_id, :null => false
      t.string :title, :null => false
      t.string :permalink, :null => false
      t.text :content
      t.timestamps
    end
    
    add_index :pages, :user_id
    add_index :pages, :permalink
  end

  def self.down
    drop_table :pages
  end
end
