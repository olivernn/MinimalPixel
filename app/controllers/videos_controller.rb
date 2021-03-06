class VideosController < MainController
  # filters
  before_filter :user_required, :load_project
  
  cache_sweeper :item_sweeper, :only => [:create, :update]
  
  public

  # GET /projects/:project_id/videos/new
  # GET /projects/:project_id/videos/new.xml
  def new
    @video = @project.videos.build
    
    respond_to do |format|
      if @user.can_add_videos?
        format.html # new.html.erb
        format.xml  { render :xml => @video }
      else
        flash[:warning] = "You cannot add any more videos, upgrade plan or remove old videos."
        format.html { redirect_to(project_url(@project, :subdomain => @user.subdomain)) }
        format.xml  { render :xml => @video.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /projects/:project_id/videos/edit
  def edit
    @video = @project.videos.find(params[:id])
  end

  # POST /projects/:project_id/videos
  # POST /projects/:project_id/videos.xml
  def create
    @video = @project.videos.build(params[:video])

    respond_to do |format|
      if @video.save
        if current_subdomain_user.facebook_user? && @video.facebook_upload
          ItemWorker.asynch_upload_video_to_facebook(:video_id => @video.id, :fb_session => facebook_session)
        end
        flash[:notice] = 'Video is being processed.'
        format.html { redirect_to(project_item_path(@project, @video, :subdomain => @user.subdomain)) }
        format.xml  { render :xml => @video, :status => :created, :location => project_video_path(project, @video) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @video.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projects/:project_id/videos/1
  # PUT /projects/:project_id/videos/1.xml
  def update
    @video = @project.videos.find(params[:id])

    respond_to do |format|
      if @video.update_attributes(params[:video])
        flash[:notice] = 'Video was successfully updated.'
        format.html { redirect_to(project_item_path(@project, @video, :subdomain => @user.subdomain)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @video.errors, :status => :unprocessable_entity }
      end
    end
  end
end
