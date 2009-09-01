class FacebookController < ApplicationController
  layout 'promotional'
  
  def link_user_accounts
    if self.current_user.nil?
      @user = User.create_from_fb_connect(facebook_session.user)
      begin
        set_up_facebook_account(@user)
        redirect_to(projects_root_path :subdomain => current_user.subdomain)
        flash[:notice] = "Logged in successfully"
      rescue ActiveRecord::RecordInvalid, ActiveRecord::StatementInvalid
        flash[:warning] = "Could not log you in with facebook"
        render :new
      end
    else
      self.current_user.link_fb_connect(facebook_session.user.id) unless self.current_user.fb_user_id == facebook_session.user.id
      redirect_to(projects_root_path :subdomain => current_user.subdomain)
      flash[:notice] = "Logged in successfully"
    end
  end
  
  def new
    
  end
  
  private
  
  def set_up_facebook_account(user)
    user.save
    @plan = Plan.for_facebook
    @plan.users << user
    if @plan.free?
      user.account.activate!
      user.activate!
    end
  end
end