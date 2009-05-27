class ApplicationController < GlobalController
  before_filter :load_profile
  
  protected
  
  # only perform action caching if the user is not logged in and the flash is empty
  def do_caching?
    !logged_in? && flash.empty?
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

