class AdminsController < ApplicationController
  skip_before_filter :check_private_beta
  before_filter :admin_user, :only => [:beta_key, :groups, :deactivate, :interests]

  # GET /admins
  # GET /admins.xml
  def index
    # @admins = Admin.all
    # 
    # respond_to do |format|
    #   format.html # index.html.erb
    #   format.xml  { render :xml => @admins }
    # end
    @admin_session = AdminSession.new
    if current_admin
      redirect_to dashboards_url
    end
  end

  # GET /admins/1
  # GET /admins/1.xml
  def show
    @admin = Admin.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @admin }
    end
  end

  def new
    @admin = Admin.new
  end

  def edit
    @admin = Admin.find(params[:id])
    render :layout => 'admin'
  end

  def create
    @admin = Admin.new(params[:admin])
    pass = @admin.password
    if @admin.save
      @admin.update_attributes(:save_password => pass)
      if current_admin.blogger.nil?
        @admin.update_attributes(:blogger => true)
      end
      redirect_to blogger_admins_url, :notice => 'Blogger was successfully created.'
    else
      render :action => "new" 
    end
  end

  # PUT /admins/1
  # PUT /admins/1.xml
  def update
    @admin = Admin.find(params[:id])
    if @admin.update_attributes(params[:admin])
      if params[:admin][:image].blank?
        flash[:notice] = "Blogger was successfully updated."
        redirect_to edit_admin_path(@admin)
      else
        render :action => "crop"
      end
    else
      render :action => 'edit'
    end


  end

  # DELETE /admins/1
  # DELETE /admins/1.xml
  def destroy
    @admin = Admin.find(params[:id])
    @admin.destroy

    respond_to do |format|
      format.html { redirect_to(admins_url) }
      format.xml  { head :ok }
    end
  end
  
  def blogger
    @admin = Admin.find(:all)
    render :layout => 'admin'
  end
  
  def beta_key
    @beta = BetaKey.first ? BetaKey.first : BetaKey.create
  
    if params[:beta_key]
      if @beta.update_attributes(params[:beta_key])
        flash[:notice] = "Update successful!"
      end
    end
    
    render :layout => 'admin'
  end
  
  def groups
    @groups = Group.all(:order => 'name')
    @groups = @groups.paginate(:page => params[:page], :per_page => 10)
    render :layout => 'admin'
  end

  def deactivate
    group = Group.find(params[:group_id])
    group.is_deactivated = true
    group.save

    redirect_to :back
  end
  
  def interests
    if params[:what]
      what = params[:what]
      
      if what == 'new'
        Interest.create(:text => params[:text], :sort_id => Interest.all.count)
      end
      
      if what == 'update'
        ids = params[:interest_id]
        ids.each_with_index do |cont, index|
          interest = Interest.find(cont)
          interest.update_attribute(:sort_id, index)
        end
      end

      if what == 'delete'
        interest = Interest.find(params[:id])
        interest.update_attribute(:is_deleted, true)
      end  
    end

    @interests = Interest.all(:order => 'sort_id ASC, text ASC')
    render :layout => 'admin'
  end
  
  def cities
    if params[:what]
      what = params[:what]
      
      if what == 'new'
        city = City.find_or_create_by_name(params[:name])
        
        city.update_attributes(:state => params[:state],
                    :abbrev => params[:abbrev],
                    :sort_id => City.all.count)
                    
        unless city.active?
          city.activate!
        end
      end
      
      if what == 'update'
        ids = params[:city_id]
        ids.each_with_index do |cont, index|
          city = City.find(cont)
          city.update_attribute(:sort_id, index)
        end
      end

      if what == 'delete'
        city = City.find(params[:id])
        city.deactivate!
      end
      
      if what == 'display'
        city = City.find(params[:id])
        city.displayed? ? city.hide! : city.display!
      end
    end
    
    @cities = City.find_all_by_is_active(true, :order => 'sort_id ASC, name ASC')
    render :layout => 'admin'
  end
  
  def tag_lines
    @tag_line = TagLine.find(1)

    render :layout => 'admin'
  end
  
  def tag_lines_update
    @tag_line = TagLine.find(1)
    @tag_line.update_attribute(:name, params[:tag_line][:name])
    
    redirect_to tag_lines_admins_url, :notice => "Tag Line is saved"
  end

private
  def admin_user
    if current_admin.blogger?
      redirect_to dashboards_url
    end
  end

end
