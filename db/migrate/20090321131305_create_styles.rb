class CreateStyles < ActiveRecord::Migration
  def self.up
    create_table :styles do |t|
      t.integer :user_id
      t.string  :logo_file_name
      t.string  :logo_content_type
      t.integer :logo_file_size
      t.string  :theme, :null => false
      t.string  :heading_font, :null => false
      t.string  :heading_colour, :null => false
      t.string  :border_type, :null => false
      t.timestamps
    end
    
    add_index :styles, :user_id
  end

  def self.down
    drop_table :styles
  end
end
