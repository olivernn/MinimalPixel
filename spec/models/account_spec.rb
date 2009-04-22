require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Account do
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :plan_id => 1,
      :next_payment_date => Date.today.to_s,
      :status => 'active',
      :profile_id => 'I-FGT436',
      :created_at => Time.now,
      :updated_at => Time.now
    }
    @account = Account.new
  end

  it "should create a new instance given valid attributes" do
    Account.create!(@valid_attributes)
  end
  
  # testing the states of an account
  it "should have an initial status of pending" do
    @account.attributes = @valid_attributes.except(:status)
    @account.save
    @account.status.should eql("pending")
  end
  
  it "should have a status of 'active' after being activated" do
    @account.attributes = @valid_attributes.except(:status)
    @account.save
    @account.activate!
    @account.status.should eql("active")
  end
  
  it "should have some transactions" do
    association = Account.reflect_on_association(:transactions)
    association.should_not be_nil
    association.macro.should eql(:has_many)
  end
  
  # it "shouldn't be able to be activated unless currently pending" do
  #   @account.attributes = @valid_attributes.except(:status)
  #   @account.status = "not pending"
  #   @account.save
  #   @account.activate!
  #   @account.status.should_not eql("active")
  # end
end
