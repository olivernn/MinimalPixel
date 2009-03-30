class AddProfileIdToAccount < ActiveRecord::Migration
  def self.up
    add_column :accounts, :profile_id, :string
  end

  def self.down
    remove_column :accounts, :profile_id
  end
end
