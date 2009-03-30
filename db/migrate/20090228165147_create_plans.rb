class CreatePlans < ActiveRecord::Migration
  def self.up
    create_table :plans do |t|
      t.string :name, :null => false
      t.decimal :price, :null => false
      t.string :payment_frequency, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :plans
  end
end
