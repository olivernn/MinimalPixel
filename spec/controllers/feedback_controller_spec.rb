require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FeedbackController do
  
  def mock_contact_form(stubs={})
    @mock_contact_form ||= mock_model(ContactForm, stubs)
  end
  
  describe "responding to a GET new" do
    it "should expose a new ContactForm as @contact_form" do
      ContactForm.should_receive(:new).and_return(mock_contact_form)
      get :new
      assigns[:contact_form].should == mock_contact_form
    end
  end
  
  describe "responding to a POST create" do
    it "should send the contact form in the background" do
      ContactForm.should_receive(:new).with({'these' => 'params'}).and_return(mock_contact_form(:valid? => true))
      MailWorker.should_receive(:async_contact_us)
      post :create, :contact_form => {'these' => 'params'}
      assigns[:contact_form].should == mock_contact_form
      flash[:notice].should == "Thank you for your message, we will get back to you shortly."
    end
    
    it "should re-direct to the home page" do
      ContactForm.stub!(:new).and_return(mock_contact_form(:valid? => true))
      MailWorker.stub!(:async_contact_us)
      post :create, :contact_form => {'these' => 'params'}
      response.should redirect_to(root_path)
    end
  end
end
