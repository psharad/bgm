class PreferencesController < ApplicationController
  # GET /preferences
  # GET /preferences.xml
  def index
    main_page_cred
    begin
      @group = Group.find(params[:group_id])
    rescue
      slug = Slug.find_by_name(params[:group_id])
      @group = Group.find(slug.sluggable_id)
    end
    
    @preference = @group.preference || Preference.new(params[:preference])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @preferences }
    end
  end

  # GET /preferences/1
  # GET /preferences/1.xml
  def show
    main_page_cred
    @preference = Preference.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @preference }
    end
  end

  # GET /preferences/new
  # GET /preferences/new.xml
  def new
    main_page_cred
    begin
      @group = Group.find(params[:group_id])
    rescue
      slug = Slug.find_by_name(params[:group_id])
      @group = Group.find(slug.sluggable_id)
    end
    @preference = @group.preference.build
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @preference }
    end
  end

  # GET /preferences/1/edit
  def edit
    main_page_cred
    # @group = current_user.groups.first(:conditions => ["expiration_date > ?", Time.now])
    @group = current_user.groups.current_group
    @preference = Preference.find_by_group_id(@group.id)
  end

  # POST /preferences
  # POST /preferences.xml
  def create
    begin
      @group = Group.find(params[:group_id])
    rescue
      slug = Slug.find_by_name(params[:group_id])
      @group = Group.find(slug.sluggable_id)
    end
    
    @preference = @group.preference || Preference.new(params[:preference])
    @preference.update_attributes(params[:preference]) unless @preference.new_record?
    @preference.group_id = @group.id
    respond_to do |format|
      if @preference.save
        format.html { redirect_to(upload_photo_group_url(@group)) }
        format.xml  { render :xml => @preference, :status => :created, :location => @preference }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @preference.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /preferences/1
  # PUT /preferences/1.xml
  def update
    @preference = Preference.find(params[:id])

    respond_to do |format|
      if @preference.update_attributes(params[:preference])
        format.html { redirect_to(upload_photo_group_url(@group)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @preference.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /preferences/1
  # DELETE /preferences/1.xml
  def destroy
    @preference = Preference.find(params[:id])
    @preference.destroy

    respond_to do |format|
      format.html { redirect_to(preferences_url) }
      format.xml  { head :ok }
    end
  end
  
  def save_preference
    respond_to do |format|
      if @preference.update_attributes(params[:preference])
        format.html { redirect_to(upload_photo_group) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @preference.errors, :status => :unprocessable_entity }
      end
    end
  end
end
