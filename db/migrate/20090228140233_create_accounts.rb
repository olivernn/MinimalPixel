class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.integer :user_id, :null => false
      t.integer :plan_id, :null => false
      t.date :next_payment_date
      t.string :status, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end
