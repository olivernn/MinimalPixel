class PagesController < ApplicationController
  before_filter :user_required, :except => :validate
  before_filter :login_required, :except => [:validate, :show]
  before_filter :user_role_required, :only => [:destroy]
  
  skip_filter :load_profile, :only => :validate
  
  caches_action :index, :show, :if => :do_caching?.to_proc, :cache_path => :cache_path.to_proc
  cache_sweeper :page_sweeper, :only => [:create, :update, :destroy]
  
  # GET /pages/validate.js
  def validate
    @page = Page.new(params[:page])
    respond_to do |format|
      format.js { render :json => {:model => 'page', :success => @page.valid?, :errors => @page.errors }}
    end
  end
  
  # GET /pages
  # GET /pages.xml
  def index
    @pages = @user.pages

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pages }
    end
  end

  # GET /pages/1
  # GET /pages/1.xml
  def show
    @page = @user.pages.find_by_permalink(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @page }
    end
  end

  # GET /pages/new
  # GET /pages/new.xml
  def new
    @page = @user.pages.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @page }
    end
  end

  # GET /pages/1/edit
  def edit
    @page = @user.pages.find_by_permalink(params[:id])
  end

  # POST /pages
  # POST /pages.xml
  def create
    @page = @user.pages.build(params[:page])

    respond_to do |format|
      if @page.save
        flash[:notice] = 'Page was successfully created.'
        format.html { redirect_to(@page) }
        format.xml  { render :xml => @page, :status => :created, :location => @page }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pages/1
  # PUT /pages/1.xml
  def update
    @page = @user.pages.find_by_permalink(params[:id])

    respond_to do |format|
      if @page.update_attributes(params[:page])
        flash[:notice] = 'Page was successfully updated.'
        format.html { redirect_to(@page) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.xml
  def destroy
    @page = @user.pages.find_by_permalink(params[:id])
    @page.destroy

    respond_to do |format|
      format.html { redirect_to(pages_url) }
      format.xml  { head :ok }
    end
  end
end
