class ProjectsController < MainController
  before_filter :user_required
  before_filter :login_required, :only => [:edit, :update, :destroy]
  before_filter :user_role_required, :only => [:destroy]
  
  caches_action :index, :show, :if => :do_caching?.to_proc, :cache_path => :cache_path.to_proc
  cache_sweeper :project_sweeper, :only => [:update, :destroy]
  
  # GET /projects
  # GET /projects.xml
  def index
    @projects = @user.projects.active.paginate(:per_page => 3, :page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.xml
  def show
    @project = @user.projects.find(params[:id])
    @items = @project.items.ready

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
    @project.remove!

    respond_to do |format|
      format.html { redirect_to(projects_url(:subdomain => @user.subdomain)) }
      format.xml  { head :ok }
    end
  end
end
