class RemoveDateFromArticles < ActiveRecord::Migration
  def self.up
    remove_column :articles, :date
  end

  def self.down
    add_column :articles, :date, :date, :null => false
  end
end
