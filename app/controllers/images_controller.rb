class ImagesController < ApplicationController
  # filters
  before_filter :user_required, :load_project
  
  public
  
  # GET /projects/:project_id/images/new
  # GET /projects/:project_id/images/new.xml
  def new
    @image = @project.images.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @image }
    end
  end

  # GET /projects/:project_id/images/edit
  def edit
    @image = @project.images.find(params[:id])
  end

  # POST /projects/:project_id/images
  # POST /projects/:project_id/images.xml
  def create
    @image = @project.images.build(params[:image])

    respond_to do |format|
      if @image.save
        flash[:notice] = 'Image was successfully created.'
        format.html { redirect_to(project_image_path(@project, @image, :subdomain => @user.subdomain)) }
        format.xml  { render :xml => @image, :status => :created, :location => project_image_path(project, @image) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @image.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projects/:project_id/images/1
  # PUT /projects/:project_id/images/1.xml
  def update
    @image = @project.images.find(params[:id])

    respond_to do |format|
      if @image.update_attributes(params[:image])
        flash[:notice] = 'Image was successfully updated.'
        format.html { redirect_to(project_image_path(@project, @image, :subdomain => @user.subdomain)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @image.errors, :status => :unprocessable_entity }
      end
    end
  end
end
