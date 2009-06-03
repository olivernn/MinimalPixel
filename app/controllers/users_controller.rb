class UsersController < PromotionalController
  skip_before_filter :verify_authenticity_token, :only => [:create, :validate]
  before_filter :load_plan, :except => [:complete, :validate]
  
  # GET /plans/:id/users/validate
  def validate
    @user = User.new(params[:user])
    respond_to do |format|
      format.js { render :json => {:model => 'user', :success => @user.valid?, :errors => @user.errors }}
    end
  end
  
  def load_plan
    begin
      @plan = Plan.find_by_name(params[:plan_id])
    rescue ActiveRecord::RecordNotFound
      logger.error "**** Couldn't find plan using #{params[:plan_id]} in load_plan ****"
      redirect_to root_url
    end
  end
  
  def new
    @user = User.new
  end

  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    if @user.save
      # @user.register!
      create_account(@user, @plan)
    else
      render :action => :new
    end      
  end
  
  def complete
    @plan = Plan.find(session[:plan_id])
    response = GATEWAY.create_profile(params[:token], @plan.payment_profile)
    @account = Account.find(session[:account_id])
    if response.success?
      if @account.update_attributes(:profile_id => response.params["profile_id"])
        @account.activate!
        @account.user.activate!
        flash[:notice] = "Account succesfully created!"
        redirect_to(projects_root_url(:subdomain => @user.subdomain))
      else
        logger.error "account with id=#{session[:account_id]} could not be updated with profile_id=#{response.params["profile_id"]}"
        flash[:error] = "there was a problem setting up your account"
        redirect_to(projects_root_url(:subdomain => @user.subdomain))
      end
    else
      logger.error "problem from paypal trying to create account with id=#{session[:account_id]} to plan #{session[:plan_id]}"
      logger.error "****** paypal response below *******"
      logger.error response.to_yaml
      logger.error "************************************"
      flash[:error] = "sorry, there was a problem creating your account."
      redirect_to(root_url(:subdomain => @user.subdomain))
    end
  end
  
  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "Signup complete! Please sign in to continue."
      redirect_to login_path
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default(root_path)
    else 
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default(root_path)
    end
  end
  
  protected
  
  def create_new_user(attributes)
    @user = User.new(attributes)
    if @user && @user.valid?
      if @user.not_using_openid?
        @user.register!
      else
        @user.register_openid!
      end
    end
    
    if @user.errors.empty?
      successful_creation(@user)
    else
      failed_creation
    end
  end
  
  def create_account(user, plan)
    plan.users << user
    session[:account_id] = user.account.id
    session[:plan_id] = plan.id
    if plan.free?
      user.account.activate!
      user.activate!
      flash[:notice] = "Signup complete! Please sign in to continue."
      redirect_to login_path
    else
      checkout(complete_account_url, root_url)
    end
  end
  
  def successful_creation(user)
    redirect_back_or_default(root_path)
    flash[:notice] = "Thanks for signing up!"
    flash[:notice] << " We're sending you an email with your activation code." if @user.not_using_openid?
    flash[:notice] << " You can now login with your OpenID." unless @user.not_using_openid?
  end
  
  def failed_creation(message = 'Sorry, there was an error creating your account')
    flash[:error] = message
    render :action => :new
  end
end
