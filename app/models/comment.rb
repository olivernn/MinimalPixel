class Comment < ActiveRecord::Base
  belongs_to :article
  
  validates_presence_of :name, :content
  validate :bot_or_not
  
  default_scope :order => "created_at"
  
  attr_accessor :anti_spam_answer, :first_number, :second_number
  
  default_value_for :first_number do
    Time.now.hour
  end
  
  default_value_for :second_number do
    Time.now.day
  end
  
  def datetime
    self.created_at.strftime("%d %b %Y at %I:%M%p")
  end
  
  def bot_or_not
    errors.add(:anti_spam_answer,  "You appear to be a bot!") unless anti_spam_answer.to_i == (first_number + second_number)
  end
end
