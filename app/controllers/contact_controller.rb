class ContactController < MainController
  # need to make sure that validate doesn't touch the database
  skip_filter :load_profile, :only => :validate
  before_filter :user_required, :except => :validate
  
  # GET /contact/validate.js
  def validate
    @contact_form = ContactForm.new(params[:contact_form])
    @contact_form.valid?
    respond_to do |format|
      format.js { render :json => {:model => 'contact_form', :success => @contact_form.valid?, :errors => @contact_form.errors }}
    end
  end
  
  # GET /contact/new
  # GET /contact/new.xml
  def new
    @contact_form = ContactForm.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end
  
  # POST /contact
  # POST /contact.xml
  def create
    @contact_form = ContactForm.new(params[:contact_form])
    @contact_form.recipient = @user.email
    
    respond_to do |format|
      if @contact_form.valid?
        MailWorker.async_contact_user(:contact_form => @contact_form)
        flash[:notice] = 'Message succesfully sent.'
        format.html { redirect_to(root_path) }
      else
        format.html { render :action => "new" }
      end
    end
  end
end
