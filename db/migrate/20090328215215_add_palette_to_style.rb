class AddPaletteToStyle < ActiveRecord::Migration
  def self.up
    add_column :styles, :palette, :text, :null => false
    remove_column :styles, :heading_colour
  end

  def self.down
    add_column :styles, :heading_colour, :string, :null => false
    remove_column :styles, :palette
  end
end
