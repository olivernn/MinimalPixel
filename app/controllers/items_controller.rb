class ItemsController < ApplicationController
  # filters
  before_filter :user_required, :load_project
  before_filter :login_required, :only => [:destroy, :index, :sort]
  before_filter :user_role_required, :only => [:destroy]
  
  # caching
  caches_action :show, :if => :do_caching?.to_proc, :cache_path => :cache_path.to_proc
  cache_sweeper :item_sweeper, :only => [:destroy, :sort]
  
  protected
  
  # override the do_caching? method so that there is no caching done when the user is logged in
  # this prevents the 'processing' page being cached, see http://londonflatmate.lighthouseapp.com/projects/31657/tickets/30-item-processing-page
  def do_caching?
    !authorized? && flash.empty?
  end
  
  public
  
  # GET /projects/:project_id/items
  # GET /projects/:project_id/items.xml
  def index
    @items = @project.items.ready
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @items }
    end
  end

  # GET /projects/:project_id/items/1
  # GET /projects/:project_id/items/1.xml
  def show
    @item = @project.items.find(params[:id])
    @style = @user.style

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @item }
      format.js # show.js.erb
    end
  end

  # DELETE /projects/:project_id/items/1
  # DELETE /projects/:project_id/items/1.xml
  def destroy
    @item = @project.items.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.html { redirect_to(project_items_path(@project, :subdomain => @user.subdomain)) }
      format.xml  { head :ok }
    end
  end
  
  # PUT /projects/:project_id/items/sort
  # PUT /projects/:project_id/items/sort.xml
  def sort
    @project.items.each do |item|
      if position = params[:items].index(item.id.to_s)
        item.update_attribute(:position, position + 1) unless item.position == position + 1
      end
    end
    render :nothing => true, :status => 200
  end
end
