class GlobalController < ActionController::Base
  # this is the top level controller, all other controllers will inherit from this one,
  # either through ApplicationController OR PromotionalController
  
  # ApplicationController becomes the top level controller for the application controllers
  # PromotinalController becomes the top level controller for the promotional site controllers
  
  include ExceptionNotifiable
  include AuthenticatedSystem
  include RoleRequirementSystem
  
  helper :all # include all helpers, all the time
  filter_parameter_logging :password, :password_confirmation
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  helper_method :current_subdomain_user
  #protect_from_forgery :secret => 'b0a876313f3f9195e9bd01473bc5cd06'
  
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
    begin
      @user ||= User.find_by_subdomain(current_subdomain)
    rescue ActiveRecord::RecordNotFound
      redirect_to root_url :subdomain => false
    end
  end
end