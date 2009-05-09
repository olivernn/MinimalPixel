class MailWorker < Workling::Base
  def contact_user(options)
    Contact.deliver_contact_user(options[:contact_form])
  end  
end