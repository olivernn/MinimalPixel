class StylesController < ApplicationController
  before_filter :user_required
  
  # GET /styles/1
  # GET /styles/1.xml
  def show
    @style = @user.style

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @style }
      format.js   # show.js.erb
      format.css  # show.css.erb
    end
  end

  # GET /styles/1/edit
  def edit
    @style = @user.style
  end

  # PUT /styles/1
  # PUT /styles/1.xml
  def update
    @style = @user.style

    respond_to do |format|
      if @style.update_attributes(params[:style])
        flash[:notice] = 'Style was successfully updated.'
        format.html { redirect_to(projects_root_url(:subdomain => @user.subdomain)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @style.errors, :status => :unprocessable_entity }
      end
    end
  end
end
