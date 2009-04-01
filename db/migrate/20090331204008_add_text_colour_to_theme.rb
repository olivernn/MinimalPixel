class AddTextColourToTheme < ActiveRecord::Migration
  def self.up
    add_column :themes, :text_colour, :string
  end

  def self.down
    remove_column :themes, :text_colour
  end
end
