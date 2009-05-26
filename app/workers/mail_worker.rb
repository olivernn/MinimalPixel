class MailWorker < Workling::Base
  def contact_user(options)
    Contact.deliver_contact_user(options[:contact_form])
  end
  
  def contact_us
    Contact.deliver_contact_us(options[:contact_form])
  end
end