class AddLimitsToPlan < ActiveRecord::Migration
  def self.up
    add_column :plans, :project_limit, :integer, :null => false
    add_column :plans, :image_limit, :integer, :null => false
    add_column :plans, :video_limit, :integer, :null => false
  end

  def self.down
    remove_column :plans, :project_limit
    remove_column :plans, :image_limit
    remove_column :plans, :video_limit
  end
end
