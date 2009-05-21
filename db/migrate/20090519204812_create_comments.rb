class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :article_id, :null => false
      t.string :name, :null => false, :default => 'Annonymous'
      t.text :content, :null => false
      t.timestamps
    end
    
    add_index :comments, :article_id
  end

  def self.down
    drop_table :comments
  end
end
