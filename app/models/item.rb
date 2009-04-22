class Item < ActiveRecord::Base
  # acts_as_ .....
  acts_as_list :scope => "project_id"
  
  # association statements
  belongs_to :project
  
  # validation statements
  validates_presence_of :name
  validates_each :date do |model, attr, value|
    begin
      DateTime.parse(value.to_s)
    rescue
      model.errors.add(attr, "date not valid")
    end
  end
  
  # override to_param method to get prettier urls
  def to_param
    "#{self.id}-#{self.name.parameterize.to_s}"
  end
end
