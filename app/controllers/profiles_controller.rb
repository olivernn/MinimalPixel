class ProfilesController < ApplicationController
  before_filter :user_required
  before_filter :user_role_required, :only => [:edit, :update]
  
  caches_action :show, :if => :do_caching?.to_proc, :cache_path => :cache_path.to_proc
  cache_sweeper :profile_sweeper, :only => [:update]
  
  # GET /profiles/1
  # GET /profiles/1.xml
  def show
    @profile = @user.profile

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @profile }
    end
  end

  # GET /profiles/1/edit
  def edit
    @profile = @user.profile
  end

  # PUT /profiles/1
  # PUT /profiles/1.xml
  def update
    @profile = @user.profile

    respond_to do |format|
      if @profile.update_attributes(params[:profile])
        flash[:notice] = 'Profile was successfully updated.'
        format.html { redirect_to(projects_root_url(:subdomain => @user.subdomain)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @profile.errors, :status => :unprocessable_entity }
      end
    end
  end
end
