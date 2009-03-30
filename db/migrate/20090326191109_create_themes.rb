class CreateThemes < ActiveRecord::Migration
  def self.up
    create_table :themes do |t|
      t.string  :name, :null => false
      t.string  :background_colour, :null => false
      t.string  :border_colour, :null => false
      t.boolean :available, :null => false, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :themes
  end
end
