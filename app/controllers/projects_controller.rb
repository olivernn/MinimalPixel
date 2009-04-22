class ProjectsController < ApplicationController
  before_filter :user_required
  
  # GET /projects
  # GET /projects.xml
  def index
    @projects = @user.projects.active.paginate(:per_page => 5, :page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.xml
  def show
    @project = @user.projects.find(params[:id])
    @items = @project.items

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = @user.projects.find(params[:id])
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    @project = @user.projects.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        flash[:notice] = 'Project was successfully updated.'
        format.html { redirect_to(project_path(@project, :subdomain => @user.subdomain)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    @project = @user.projects.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to(project_url(:subdomain => @user.subdomain)) }
      format.xml  { head :ok }
    end
  end
end
