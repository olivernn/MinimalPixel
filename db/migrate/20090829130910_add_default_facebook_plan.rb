class AddDefaultFacebookPlan < ActiveRecord::Migration
  def self.up
    add_column :plans, :facebook_default, :boolean
  end

  def self.down
    remove_column :plans, :facebook_default
  end
end
