class MainController < ApplicationController
  before_filter :set_facebook_session
  helper_method :facebook_session
  
  before_filter :load_profile
  
  protected
  
  # custom cache path, takes into account pagination, format and if this should be in the public or private cache
  def cache_path   
    path = [current_subdomain, params[:controller], params[:action], params[:id] ].compact.join("/")
    {:format => request.format.to_s.split("/").last, :public => !authorized?, :page => params[:page] || 1}.each {|key, value| path << "?" +  key.to_s + "=" + value.to_s}
    path
  end
  
  # don't cache if there is a flash message to display
  def do_caching?
    flash.empty?
  end
  
  def user_required
    begin
      current_subdomain_user # this method will raise an exception if the current subdomain user can't be found
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "Couldn't find the user #{current_subdomain}"
      redirect_to root_url(:subdomain => false)
    end
  end
  
  def load_profile
    begin
      @profile ||= current_subdomain_user.profile
    rescue ActiveRecord::RecordNotFound
      redirect_to root_url(:subdomain => false)
    end
  end
  
  def load_project
    begin
      @project = @user.projects.find(params[:project_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to projects_url
    end
  end
  
  def user_role_required
    unless current_subdomain_user.has_role?(:user)
      flash[:warning] = "Insufficient Authority"
      redirect_to projects_url
    end
  end
end

