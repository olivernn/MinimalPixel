class AddThemeAndFontToStyle < ActiveRecord::Migration
  def self.up
    add_column :styles, :theme_id, :integer, :null => false
    add_column :styles, :font_id, :integer, :null => false
  end

  def self.down
    remove_column :styles, :theme_id
    remove_column :styles, :font_id
  end
end
