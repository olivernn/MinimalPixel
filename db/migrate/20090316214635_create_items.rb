class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.integer :project_id, :null => false
      t.integer :position, :null => false
      t.string  :name, :null => false
      t.text    :description
      t.date    :date
      t.string  :source_file_name
      t.string  :source_content_type
      t.integer :source_file_size
      t.timestamps
    end
    
    add_index :items, :project_id
    add_index :items, :position
  end

  def self.down
    drop_table :items
  end
end
