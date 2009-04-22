class CreateTransactions < ActiveRecord::Migration
  def self.up
    create_table :transactions do |t|
      t.integer :account_id, :null => false
      t.string :status
      t.date :date
      t.decimal :amount
      t.timestamps
    end
    
    add_index :transactions, :account_id
    add_index :transactions, :status
  end

  def self.down
    drop_table :transactions
  end
end
