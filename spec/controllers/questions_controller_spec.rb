require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe QuestionsController do
  
  def mock_question(stubs={})
    @mock_question ||= mock_model(Question, stubs)
  end
  
  describe "responding to a GET index" do
    it "should expose all questions as @questions" do
      Question.should_receive(:find).with(:all).and_return([mock_question])
      get :index
      assigns[:questions].should == [mock_question]
    end
  end
  
  describe "responding to a GET show" do
    it "should render the requested question as @question" do
      Question.should_receive(:find).with("1").and_return(mock_question)
      get :show, :id => "1"
      assigns[:question].should == mock_question
    end
  end
  
  describe "responding to a GET new" do
    it "should expose a newly built but not saved question as @question" do
      Question.should_receive(:new).and_return(mock_question)
      get :new
      assigns[:question].should == mock_question
    end
  end
  
  describe "responding to a POST create" do
    describe "with valid parameters" do
      it "should create a new question" do
        Question.should_receive(:new).with({'these' => 'params'}).and_return(mock_question(:save => true))
        post :create, :question => {'these' => 'params'}
        assigns[:question].should == mock_question
        flash[:notice].should == 'Successfully created question'
      end
      
      it "should redirect to the question index page" do
        Question.stub!(:new).and_return(mock_question(:save => true))
        post :create, :question => {'these' => 'params'}
        response.should redirect_to(questions_path)
      end
    end
    
    describe "with invalid parameters" do
      it "should not create a new question" do
        Question.should_receive(:new).with({'invalid' => 'params'}).and_return(mock_question(:save => false))
        post :create, :question => {'invalid' => 'params'}
        assigns[:question].should == mock_question
      end
      
      it "should re-render the form populated with the invalid question" do
        Question.stub!(:new).and_return(mock_question(:save => false))
        post :create
        response.should render_template('new')
      end
    end
  end
  
  describe "responding to a GET edit" do
    it "should expose the requested question as @question" do
      Question.should_receive(:find).with("1").and_return(mock_question)
      get :edit, :id => "1"
      assigns[:question].should == mock_question
    end
  end
  
  describe "responding to a PUT update" do
    describe "with valid parameters" do
      it "should update the question" do
        Question.should_receive(:find).with("1").and_return(mock_question(:update_attributes => true))
        put :update, :id => "1"
        assigns[:question].should == mock_question
        flash[:notice].should == "Successfully updated question"
      end
      
      it "should redirect to the question index" do
        Question.stub!(:find).and_return(mock_question(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(question_path(mock_question))
      end
    end
    
    describe "with invalid parameters" do
      it "should not update the question" do
        Question.should_receive(:find).with("1").and_return(mock_question(:update_attributes => false))
        put :update, :id => "1"
        assigns[:question].should == mock_question
      end
      
      it "should re-render the edit form" do
        Question.stub!(:find).and_return(mock_question(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end
  end
end
