class AddPromotionalIndexes < ActiveRecord::Migration
  def self.up
    add_index :articles, :status
    add_index :plans, :name
    add_index :plans, :available
  end

  def self.down
    remove_index :articles, :status
    remove_index :plans, :name
    remove_index :plans, :available
  end
end
