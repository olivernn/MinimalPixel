class Account < ActiveRecord::Base
  # relationships
  belongs_to :user
  belongs_to :plan
  
  # state machine modelling
  include AASM
  aasm_column :status
  aasm_initial_state :pending
  
  aasm_state :pending
  aasm_state :active
  aasm_state :cancelled
  aasm_state :refused
  aasm_state :overdue
  aasm_state :locked
  
  # activating an account should move status from pending to active
  aasm_event :activate do
    transitions :to => :active, :from => :pending
  end
end
