class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create
  before_filter :load_plan, :except => :complete
  
  def load_plan
    begin
      @plan = Plan.find(params[:plan_id])
    rescue ActiveRecord::RecordNotFound
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
      @user.register!
      create_account(@user, @plan)
    else
      render :action => :new
    end      
  end
  
  def complete
    @gateway ||= set_up_gateway
    response = @gateway.create_profile(params[:token], :description => "test_description", :start_date => Time.now, :frequency => 2, :amount => 16, :auto_bill_outstanding => true)
    @account = Account.find(session[:account_id])
    logger.debug response.to_yaml
    if response.success?
      if @account.update_attributes(:profile_id => response.params["profile_id"])
        logger.debug "account updated"
        @account.activate!
        @account.user.activate!
        flash[:notice] = "account succesfully created"
        render :nothing => true
      else
        logger.error "account with id=#{session[:account_id]} could not be updated with profile_id=#{response.params["profile_id"]}"
        flash[:error] = "there was a problem setting up your account"
        render :nothing => true
      end
    else
      logger.debug "problem from paypal"
      flash[:error] = "there was a problem setting up your account"
      render :nothing => true
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
    if plan.free?
      user.account.activate!
      user.activate!
      flash[:notice] = "Signup complete! Please sign in to continue."
      redirect_to login_path
    else
      checkout
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
  
  def checkout
    @gateway ||= set_up_gateway
    description = "subscription to minimal pixel"
    response = @gateway.setup_agreement(:description => description, :return_url => complete_account_url, :cancel_return_url => root_url)
    redirect_to @gateway.redirect_url_for(response.token)
  end
  
  def set_up_gateway
    # these are the test credentials -- need changing before live.
    ActiveMerchant::Billing::PaypalExpressRecurringGateway.new(
      :login => 'oliver_1218302408_biz_api1.ntlworld.com',
      :password => '95X5HJ8WG2SRBPB2',
      :signature => 'AH1eOAAdxH9dz4bJ8jTBB9jd0rv7AUvGZZ3ZuXIXmV77iCPhPlGt9YM.')
  end
end
