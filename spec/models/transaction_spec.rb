require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Transaction do
  before(:each) do
    @valid_attributes = {
      :account_id => 1,
      :status => 'pending',
      :date => Time.now,
      :amount => 10.00
    }
    @transaction = Transaction.new
  end

  it "should create a new instance given valid attributes" do
    Transaction.create!(@valid_attributes)
  end
  
  it "should have an initial state of 'pending'" do
    @transaction.attributes = @valid_attributes.except(:status)
    @transaction.save
    @transaction.status.should eql('pending')
  end
  
  it "should have a status of 'successful' after being completed successfully" do
    @transaction.attributes = @valid_attributes.except(:status)
    @transaction.save!
    @transaction.completed_successfully!
    @transaction.status.should eql('successful')
  end
  
  it "should have a status of 'failed' after a fail" do
    @transaction.attributes = @valid_attributes.except(:status)
    @transaction.save!
    @transaction.fail!
    @transaction.status.should eql('failed')
  end
  
  it "should have a named scope of pending" do
    Transaction.pending.proxy_options.should == {:conditions => {:status => 'pending'}}
  end
  
  it "should have a named scope of failed" do
    Transaction.failed.proxy_options.should == {:conditions => {:status => 'failed'}}
  end
  
  it "should have some items" do
    association = Transaction.reflect_on_association(:account)
    association.should_not be_nil
    association.macro.should eql(:belongs_to)
  end
end
