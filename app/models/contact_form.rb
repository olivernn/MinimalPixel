class ContactForm < Tableless
  column :name, :string
  column :email, :string
  column :message, :text
  column :recipient, :string
  
  validates_presence_of :name, :email, :message
  include ValidationRegExp
  validates_format_of :email, :with => EMAIL_ADDRESS
  validates_format_of :recipient, :with => EMAIL_ADDRESS
end