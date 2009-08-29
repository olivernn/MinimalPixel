class AccountsController < MainController
  before_filter :user_role_required, :only => [:edit, :update, :upgrade, :destroy]
  before_filter :user_required, :login_required
  
  # GET /accounts/1
  # GET /accounts/1.xml
  def show
    @account = @user.account
    @transactions = @account.transactions

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @account }
    end
  end

  # GET /accounts/1/edit
  def edit
    @account = @user.account
    @plans = Plan.offerable
    @plans << @user.plan
    @plans.uniq!
  end

  # PUT /accounts/1
  # PUT /accounts/1.xml
  def update
    @account = @user.account
    @plan = Plan.find(params[:account][:plan_id])
    
    if @account.plan_change_valid?(@plan)
      if @plan.free?
        respond_to do |format|
          if @account.update_attributes(params[:account])
            flash[:notice] = 'Account was successfully updated.'
            format.html { redirect_to(account_path(@account, :subdomain => @user.subdomain)) }
            format.xml  { head :ok }
          else
            format.html { render :action => "edit" }
            format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
          end
        end
      else
        session[:account_id] = @account.id
        session[:plan_id] = @plan.id
        checkout(upgrade_account_url, projects_root_url(:subdomain => @user.subdomain))
      end
    else
      flash[:warning] = "Account plan could not be changed."
      redirect_to(projects_root_url(:subdomain => @user.subdomain))
    end
  end
  
  def upgrade
    @plan = Plan.find(session[:plan_id])
    response = GATEWAY.create_profile(params[:token], @plan.payment_profile)
    @account = Account.find(session[:account_id])
    if response.success?
      if @account.update_attributes(:profile_id => response.params["profile_id"], :plan_id => session[:plan_id])
        @account.initial_transaction # create the initial transaction
        flash[:notice] = "Account succesfully upgraded."
        redirect_to(projects_root_url(:subdomain => @user.subdomain))
      else
        logger.error "account with id=#{session[:account_id]} could not be updated with profile_id=#{response.params["profile_id"]}"
        flash[:error] = "sorry, there was a problem upgrading your account."
        redirect_to(projects_root_url(:subdomain => @user.subdomain))
      end
    else
      logger.error "problem from paypal trying to upgrade account with id=#{session[:account_id]} to plan #{session[:plan_id]}"
      logger.error "****** paypal response below *******"
      logger.error response.to_yaml
      logger.error "************************************"
      flash[:error] = "sorry, there was a problem upgrading your account."
      redirect_to(projects_root_url(:subdomain => @user.subdomain))
    end
  end
  
  # DELETE /accounts/1
  # DELETE /accounts/1.xml
  def destroy
    @account = @user.account.find(params[:id])
    @account.start_cancellation!
    @user.suspend!
    
    flash[:notice] = "Your account has been scheduled for cancellation"
    
    respond_to do |format|
      format.html { redirect_to(root_url, :subdomain => false) }
      format.xml  { head :ok }
    end
  end
end
