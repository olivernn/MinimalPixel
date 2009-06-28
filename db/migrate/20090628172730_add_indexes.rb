class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index :users, :subdomain
    
    add_index :accounts, :user_id
    add_index :accounts, :plan_id
    
    add_index :items, :status
    
    add_index :styles, :theme_id
    add_index :styles, :font_id
  end

  def self.down
    remove_index :users, :subdomain
    
    remove_index :accounts, :user_id
    remove_index :accounts, :plan_id
    
    remove_index :items, :status
    
    remove_index :styles, :theme_id
    remove_index :styles, :font_id
  end
end
