class Article < ActiveRecord::Base
  validates_presence_of :title, :content, :permalink
  validates_uniqueness_of :permalink
  
  before_validation_on_create :create_permalink
  
  acts_as_textiled :content
  
  has_many :comments
  
  # note that initial state must also be declared as a state
  include AASM
  aasm_column :status
  aasm_initial_state :draft
  aasm_state :draft
  aasm_state :active
  
  aasm_event :publish do
    transitions :to => :active, :from => [:draft]
  end
  
  def create_permalink
    self.permalink = self.title.parameterize.to_s if self.title
  end
  
  def date
    self.created_at.strftime("%d %B %Y") if self.created_at
  end
  
  def to_param
    self.id.to_s + "-" + self.title.parameterize.to_s
  end
end
