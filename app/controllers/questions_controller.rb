class QuestionsController < ApplicationController
  layout 'promotional'
  skip_filter :load_profile
  require_role :admin, :except => [:index, :show]
  
  def index
    @questions = Question.find(:all)
  end
  
  def show
    @question = Question.find(params[:id])
    
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def new
    @question = Question.new
  end
  
  def create
    @question = Question.new(params[:question])
    
    if @question.save
      flash[:notice] = "Successfully created question"
      redirect_to questions_path
    else
      render :action => 'new'
    end
  end
  
  def edit
    @question = Question.find(params[:id])
  end
  
  def update
    @question = Question.find(params[:id])
    
    if @question.update_attributes(params[:question])
      flash[:notice] = "Successfully updated question"
      redirect_to question_path(@question)
    else
      render :action => 'edit'
    end
  end
end
