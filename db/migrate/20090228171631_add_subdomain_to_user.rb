class AddSubdomainToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :subdomain, :string, :null => false
  end

  def self.down
    remove_column :users, :subdomain
  end
end
