class Question < ActiveRecord::Base
  validates_presence_of :question, :answer
  
  before_save :add_question_mark
  
  acts_as_textiled :answer
  
  def add_question_mark
    unless self.question.include?('?')
      self.question = self.question << "?"
    end
  end
end
