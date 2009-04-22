class ApplicationController < ActionController::Base
  include ExceptionNotifiable
  include AuthenticatedSystem
  include RoleRequirementSystem

  helper :all # include all helpers, all the time
  #protect_from_forgery :secret => 'b0a876313f3f9195e9bd01473bc5cd06'
  filter_parameter_logging :password, :password_confirmation
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  helper_method :current_subdomain_user
  before_filter :load_profile
  
  protected
  
  def set_up_gateway
    # these are the test credentials -- need changing before live.
    ActiveMerchant::Billing::PaypalExpressRecurringGateway.new(
      :login => 'oliver_1218302408_biz_api1.ntlworld.com',
      :password => '95X5HJ8WG2SRBPB2',
      :signature => 'AH1eOAAdxH9dz4bJ8jTBB9jd0rv7AUvGZZ3ZuXIXmV77iCPhPlGt9YM.')
  end
  
  def checkout(return_url, cancel_url)
    @gateway ||= set_up_gateway
    description = "subscription to minimal pixel"
    response = @gateway.setup_agreement(:description => description, :return_url => return_url, :cancel_return_url => cancel_url)
    redirect_to @gateway.redirect_url_for(response.token)
  end
  
  # Automatically respond with 404 for ActiveRecord::RecordNotFound
  def record_not_found
    render :file => File.join(RAILS_ROOT, 'public', '404.html'), :status => 404
  end
  
  def access_denied
    store_location
    logger.info "unauthorized access attempt from #{request.remote_ip}"
    redirect_to login_path
    false
  end
  
  def current_subdomain_user
    @user ||= User.find_by_subdomain(current_subdomain)
  end
  
  def user_required
    unless current_subdomain_user
      flash[:error] = "Couldn't find the user #{current_subdomain}"
      redirect_to root_url
    end
  end
  
  def load_profile
    begin
      @profile ||= current_subdomain_user.profile
    rescue ActiveRecord::RecordNotFound
      redirect_to root_url
    end
  end
  
  def load_project
    begin
      @project = @user.projects.find(params[:project_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to projects_url
    end
  end
end

