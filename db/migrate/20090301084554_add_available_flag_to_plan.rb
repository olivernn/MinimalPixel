class AddAvailableFlagToPlan < ActiveRecord::Migration
  def self.up
    add_column :plans, :available, :boolean, :null => false
  end

  def self.down
    remove_column :plans, :available
  end
end
