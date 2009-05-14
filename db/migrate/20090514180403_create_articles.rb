class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.string :title, :null => false
      t.text :content, :null => true
      t.date :date, :null => false
      t.string :permalink, :null => false
      t.string :status, :null => false
      t.timestamps
    end
    
    add_index :articles, :permalink
  end

  def self.down
    drop_table :articles
  end
end
