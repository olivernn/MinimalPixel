class RemoveThemeAndFontColumnsFromStyle < ActiveRecord::Migration
  def self.up
    remove_column :styles, :theme
    remove_column :styles, :heading_font
  end

  def self.down
    add_column :styles, :theme, :string, :null => false
    add_column :styles, :heading_font, :string, :null => false
  end
end
