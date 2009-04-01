class CreateFonts < ActiveRecord::Migration
  def self.up
    create_table :fonts do |t|
      t.string  :name, :null => false
      t.string  :font_file_name
      t.string  :font_content_type
      t.integer :font_file_size
      t.timestamps
    end
  end

  def self.down
    drop_table :fonts
  end
end
