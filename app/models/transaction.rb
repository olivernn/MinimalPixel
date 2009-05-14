class Transaction < ActiveRecord::Base
  # scopes
  default_scope :order => 'date DESC'
  
  # association statements
  belongs_to :account
  
  # state machine modelling
  include AASM
  aasm_column :status
  aasm_initial_state :pending
  
  aasm_state :pending
  aasm_state :successful, :enter => :create_pending_transaction
  aasm_state :failed, :enter => :retry_payment
  aasm_state :retry
  
  aasm_event :completed_successfully do
    transitions :to => :successful, :from => [:pending, :retry]
  end
  
  aasm_event :fail do
    transitions :to => :failed, :from => [:pending, :retry]
  end
  
  def create_pending_transaction
    account = self.account
    Transaction.create!(:account_id => account.id, :date => account.profile.params['next_billing_date'], :amount => account.profile.params['amount'])
  end
  
  def retry_payment
    account = self.account
    Transaction.create!(:account_id => account.id, :status => 'retry', :date => (Time.now + 3.days).strftime('%Y-%m-%d'), :amount => account.profile.params['outstanding_balance'])
  end
  
  def self.initial_payment(account)
    create!(:account_id => account.id, :date => account.profile.params['next_billing_date'], :amount => account.profile.params['amount'])
  end
end
