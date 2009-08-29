class StylesController < MainController
  before_filter :user_required
  before_filter :login_required, :except => :index
  
  skip_filter :load_profile, :only => :index
  
  caches_action :index
  cache_sweeper :style_sweeper, :except => :edit
  
  # GET /styles
  # GET /styles.css
  def index
    @style = @user.style
    
    if stale?(:last_modified => @style.updated_at.utc, :etag => @style)
      respond_to do |format|
        format.js   # show.js.erb
        format.css  # show.css.erb
      end
    end
  end

  # GET /styles/1/edit
  def edit
    @themes = Theme.available
    @fonts = Font.find(:all)
    @style = @user.style
  end

  # PUT /styles/1
  # PUT /styles/1.xml
  def update
    @style = @user.style

    respond_to do |format|
      if @style.update_attributes(params[:style])
        flash.now[:notice] = 'Style was successfully updated.'
        format.html { redirect_to(projects_root_url(:subdomain => @user.subdomain)) }
        format.xml  { head :ok }
        format.js
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @style.errors, :status => :unprocessable_entity }
      end
    end
  end
end
