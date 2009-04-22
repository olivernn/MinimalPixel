class ItemsController < ApplicationController
  # filters
  before_filter :user_required, :load_project
  
  public
  
  # GET /projects/:project_id/items
  # GET /projects/:project_id/items.xml
  def index
    @items = @project.items
    
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
