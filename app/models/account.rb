class Account < ActiveRecord::Base
  # relationships
  belongs_to :user
  belongs_to :plan
  has_many :transactions
  
  # state machine modelling
  include AASM
  aasm_column :status
  aasm_initial_state :pending
  
  aasm_state :pending, :exit => :initial_transaction
  aasm_state :active
  aasm_state :cancel_pending
  aasm_state :cancelled
  aasm_state :overdue, :enter => :fail_transaction
  
  # activating an account should move status from pending to active
  aasm_event :activate do
    transitions :to => :active, :from => :pending
  end
  
  aasm_event :start_cancellation do
    transitions :to => :cancel_pending, :from => [:pending, :active, :overdue]
  end
  
  aasm_event :cancel do
    transitions :to => :cancelled, :from => [:cancel_pending]
  end
  
  aasm_event :suspend do
    transitions :to => :overdue, :from => [:active]
  end
  
  named_scope :chargeable, {
    :select => "accounts.*",
    :joins => "INNER JOIN plans ON plans.id = accounts.plan_id",
    :conditions => "plans.price > 0 AND accounts.status = 'active'"
  }
  
  # method to set up the initial transaction after creating a paid account
  def initial_transaction
    unless self.profile_id.nil?
      Transaction.create!(:account_id => self.id, :date => self.profile.params['next_billing_date'], :amount => self.profile.params['amount'])
    end
  end
  
  def fail_transaction
    unless self.profile_id.nil?
      self.transactions.pending.first.fail
    end
  end
  
  def plan_change_valid?(new_plan)
    total_images = total_videos = 0
    self.user.projects.each {|p| total_images = total_images + p.images.count}
    # self.user.projects.each {|p| total_videos = total_videos + p.videos.count}
    
    new_plan.id != self.plan.id && new_plan.project_limit >= self.user.projects.count && new_plan.image_limit >= total_images #&& new_plan.video_limit >= total_videos
  end
  
  # below are methods that interact with paypal for handling the payment profile
  def profile
    @profile ||= GATEWAY.get_profile_details(self.profile_id) unless profile_id.nil?
  end
  
  def profile_status
    profile.params["profile_status"] unless profile_id.nil?
  end
  
  def reactivate_profile
    unless self.profile_id.nil?
      response = GATEWAY.reactivate_profile(self.profile_id)
      @profile = GATEWAY.get_profile_details(self.profile_id) unless @profile.nil? # need to reset the profile
      response.success?
    end
  end
  
  def suspend_profile
    unless self.profile_id.nil?
      response = GATEWAY.suspend_profile(self.profile_id)
      @profile = GATEWAY.get_profile_details(self.profile_id) unless @profile.nil? # need to reset the profile
      response.success?
    end
  end
  
  def bill_outstanding_amount
    unless self.profile_id.nil?
      response = GATEWAY.bill_outstanding_amount(self.profile_id, :amount => self.profile.params['outstanding_balance'])
      @profile = GATEWAY.get_profile_details(self.profile_id) unless @profile.nil? # need to reset the profile
      response.success?
    end
  end
  
  def cancel_profile
    unless self.profile_id.nil?
      response = GATEWAY.cancel_profile(self.profile_id)
      @profile = GATEWAY.get_profile_details(self.profile_id) unless @profile.nil? # need to reset the profile
      response.success?
    end
  end
end
