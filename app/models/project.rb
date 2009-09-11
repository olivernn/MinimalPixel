class Project < ActiveRecord::Base
  # association statements
  belongs_to :user
  has_many :items, :dependent => :destroy
  has_many :images
  has_many :videos
  
  # validation statements
  validates_presence_of :name
  validates_length_of :name, :maximum => 20
  validates_date :date, :allow_nil => true
  validate_on_create :project_limits
  
  attr_accessible :name, :description
  
  # state machine modelling
  include AASM
  aasm_column :status
  aasm_initial_state :draft
  
  aasm_state :draft
  aasm_state :active
  aasm_state :removed, :enter => :destroy_later
    
  # publishing a project moves the status from draft to active, it also moves a project from removed to active
  aasm_event :publish do
    transitions :to => :active, :from => [:draft, :removed]
  end
  
  # removing a project moves the status from active to removed
  aasm_event :remove do
    transitions :to => :removed, :from => [:active]
  end
  
  # named scopes
  named_scope :active,  :conditions => {:status => "active"}, :order => 'created_at DESC'
  named_scope :drafts,  :conditions => {:status => "draft"}
  named_scope :removed, :conditions => {:status => "removed"}
  
  def to_param
    "#{self.id}-#{self.name.parameterize.to_s}"
  end
  
  def project_limits
    unless self.user.can_create_projects?
      errors.add_to_base("You cannot add any more projects, upgrade plan or remove old projects.")
    end
  end
  
  def destroy_later
    ProjectWorker.asynch_destroy(:project_id => self.id)
  end
end
