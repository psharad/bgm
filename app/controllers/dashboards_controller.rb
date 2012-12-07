class DashboardsController < ApplicationController
  skip_before_filter :check_private_beta
  def index
    if current_admin.blogger == true
      @dashboards = Dashboard.find_all_by_blogger_id(current_admin.id, :order => "created_at DESC", :limit => 100)
    else
      @dashboards = Dashboard.find(:all, :order => "created_at DESC", :limit => 100)
    end
    @dashboards = @dashboards.paginate(:page => params[:page], :per_page => 10)
    @images = Image.all
    @posts = Post.all
    
    render :layout => 'admin'
  end

  def show
    @dashboard = Dashboard.find(params[:id])
  end

  def new
    @dashboard = Dashboard.new
  end

  def create
    @dashboard = Dashboard.new(params[:dashboard])
    if @dashboard.save
      # flash[:notice] = "Successfully created dashboard."
      redirect_to @dashboard
    else
      render :action => 'new'
    end
  end

  def edit
    @dashboard = Dashboard.find(params[:id])
  end

  def update
    @dashboard = Dashboard.find(params[:id])
    if @dashboard.update_attributes(params[:dashboard])
      # flash[:notice] = "Successfully updated dashboard."
      redirect_to @dashboard
    else
      render :action => 'edit'
    end
  end

  def destroy
    @dashboard = Dashboard.find(params[:id])
    @dashboard.destroy
    # flash[:notice] = "Successfully destroyed dashboard."
    redirect_to dashboards_url
  end
end
