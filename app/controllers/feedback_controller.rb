class FeedbackController < PromotionalController
  tab :feedback
  
  def validate
    @contact_form = ContactForm.new(params[:contact_form])
    @contact_form.valid?
    respond_to do |format|
      format.js { render :json => {:model => 'contact_form', :success => @contact_form.valid?, :errors => @contact_form.errors }}
    end
  end
  
  def new
    @contact_form = ContactForm.new
  end
  
  def create
    @contact_form = ContactForm.new(params[:contact_form])
    @contact_form.recipient = APP_CONFIG[:admin_email]
    
    if @contact_form.valid?
      MailWorker.async_contact_us(:contact_form => @contact_form)
      flash[:notice] = "Thank you for your message, we will get back to you shortly."
      redirect_to root_url
    else
      render :action => 'new'
    end
  end
end
