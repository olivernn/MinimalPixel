class Contact < ActionMailer::Base
  def contact_user(contact)
    logger.debug "***** Sending the user contact email!"
    @subject = 'Portfolio Contact'
    @body["message"] = contact.message
    @body["email"] = contact.email
    @body["sender"] = contact.name
    @recipients = contact.recipient
    @from = contact.email
    @sent_on = Time.now
    @headers = {}
  end
  
  def contact_us(contact)
    logger.debug "***** Sending the contact us email *****"
    @subject = 'MinimalPixel Contact Form'
    @body["message"] = contact.message
    @body["email"] = contact.email
    @body["sender"] = contact.name
    @recipients = contact.recipient
    @from = contact.email
    @sent_on = Time.now
    @headers = {}
  end
end