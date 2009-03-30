class DraftProjectsController < ApplicationController
  before_filter :user_required, :login_required
  
  # GET /draft_projects
  # GET /draft_projects.xml
  def index
    @projects = @user.projects.drafts

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projects }
    end
  end
  
  # GET /draft_projects/new
  # GET /draft_projects/new.xml
  def new
    @project = @user.projects.build

    respond_to do |format|
      if @user.can_create_projects?
        format.html # new.html.erb
        format.xml  { render :xml => @project }
      else
        format.html { redirect_to(draft_projects_url(:subdomain => @user.subdomain)) }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # POST /draft_projects
  # POST /draft_projects.xml
  def create
    @project = @user.projects.build(params[:project])
    
    respond_to do |format|
      if @project.save
        flash[:notice] = 'Project was successfully created.'
        format.html { redirect_to(project_path(@project, :subdomain => @user.subdomain)) }
        format.xml  { render :xml => @project, :status => :created, :location => @project }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /draft_projects/:id/publish
  # PUT /draft_projects/:id/publish.xml
  def publish
    @project = @user.projects.find(params[:id])
    
    respond_to do |format|
      if @project.publish!
        flash[:notice] = "Project was succesfully published."
        format.html { redirect_to(project_path(@project, :subdomain => @user.subdomain)) }
        format.xml  { render :xml => @project, :status => :created, :location => @project }
      else
        flash[:notice] = "Project could not be published."
        format.html { redirect_to(project_path(@project, :subdomain => @user.subdomain)) }
        # TODO: need to make sure the xml returned for a failed create shows the correct error
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end 
  end
  
end
