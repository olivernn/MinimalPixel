class FacebookController < ApplicationController
  layout 'promotional'
  def link_user_accounts
    if self.current_user.nil?
      plan = Plan.for_facebook
      user = User.create_from_fb_connect(facebook_session.user)
      plan.users << user
      if plan.free?
        user.account.activate!
        user.activate!
      end
    else
      self.current_user.link_fb_connect(facebook_session.user.id) unless self.current_user.fb_user_id == facebook_session.user.id
    end
    redirect_to(projects_root_path :subdomain => current_user.subdomain)
    flash[:notice] = "Logged in successfully"
  end
end