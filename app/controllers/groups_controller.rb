class GroupsController < ApplicationController
  before_filter :initialize_group, :only => [:show, :edit, :update, :destroy, :upload_photo, :save_uploaded_photo, :email, :choose_album, :album, :save_fb_image, :remove, :no_member, :edit_photo, :save_edit_photo, :deactivate]
  before_filter :logged_in, :except => [:new, :create, :show, :edit, :check_group, :report, :login_again]
  before_filter :group_owner, :except => [:new, :create, :show, :mail_sent, :edit, :check_group, :email, :report, :delete_member, :login_again]
  skip_before_filter :check_private_beta, :only => [:choose_album, :login_again]
  
  def index
    @groups = current_user.group
    main_page_cred
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @groups }
    end
  end

  def show
    main_page_cred
    respond_to do |format|
      format.html
    end
  end

  def new
    main_page_cred
    @group = current_user.groups.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @group }
    end
  end

  def edit
    main_page_cred
    @group = current_user.groups.current_group
    if params[:extend]
      @group.update_attribute(:expiration_date, @group.expiration_date + 7.days)
      flash[:notice] = "Expiration date has been reset to  #{@group.expiration_date}"
      redirect_to root_url
    end
  end

  def create
    @group = current_user.groups.build(params[:group])
    @group.expiration_date = Time.now + 7.days
    respond_to do |format|
      if @group.save
        # format.html { redirect_to(new_member_path) }
        # format.html { redirect_to(new_group_member_path(@group)) }
        format.html { redirect_to new_group_member_url(@group, rbtokenizer.merge(:mpos => 1))}
        format.xml  { render :xml => @group, :status => :created, :location => @group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @group.update_attributes(params[:group])
        flash[:notice] = "Group update completed."
        format.html { redirect_to(edit_group_url(@group)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @group.destroy

    respond_to do |format|
      format.html { redirect_to(group_url) }
      format.xml  { head :ok }
    end
  end
  
  def upload_photo
    main_page_cred
    if params[:clr]
      cookies.delete :access_token
    end
    respond_to do |format|
      if @group.save
        session[:group] = @group.id
        format.html 
        format.xml  { render :xml => @group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end        
    end
  end
  
  def edit_photo
    main_page_cred
    if params[:clr]
      cookies.delete :access_token
    end
  end
  
  def save_edit_photo
    respond_to do |format|
      if @group.update_attributes(params[:group])
        format.html { redirect_to(edit_photo_group_url(@group)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def save_uploaded_photo
    respond_to do |format|
      if @group.update_attributes(params[:group])
        format.html { redirect_to(upload_photo_group_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def email
    main_page_cred
  end
  
  def mail_sent
    main_page_cred
    @group = Group.find(params[:email][:group_id])
    Emailer.deliver_email_with_message(@group, current_user, params[:email][:message])
  end
  
  def initialize_group
    begin
      @group = Group.find(params[:id])
    rescue
      slug = Slug.find_by_name(params[:id])
      if !slug.nil?
        @group = Group.find(slug.sluggable_id)
      end
    end
  end
  
  def choose_album
    main_page_cred
    session[:user_id] = current_user.id
    begin
      session[:group_id] = @group.id
      if params[:f]
        session[:f] = params[:f]
      end
      if fb_logged_in
        session.delete :group_id
        session.delete :f
        @albums = current_fb_session.rest('photos.getAlbums')
        # @photos = current_fb_session.fql("select src_small from photo where aid='#{profile_pictures}'")
      end
    rescue
      @handler = "hehe"
    end
  end
  
  def album
    main_page_cred
    @photos = current_fb_session.fql("select src from photo where aid='#{params[:album]}'")
  end
  
  def save_fb_image
    @group.picture_from_url(params[:fb_image])
    @group.save
    unless params[:f]
      redirect_to upload_photo_group_url
    else
      redirect_to edit_photo_group_url(@group)
    end
  end
  
  def check_group
    @grp = Group.find_by_name(params[:group])
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def group_owner
    unless (!@group.nil?) and @group.user_id.eql?(current_user.id)
      redirect_to root_url
    end
  end
  
  def report
    main_page_cred
    begin
      membership = Membership.all(:conditions => {:group_id => params[:kz], :member_id => params[:pq], :token => params[:f]}).first
      membership.delete
      member = Member.find(params[:pq])
      member.delete
      group = Group.find(params[:kz])
      Emailer.deliver_report(group)
    rescue
      @notice = "Action cannot be performed"
    end
  end
  
  def remove
    main_page_cred
  end

  def login_again
    @user = User.find(params[:lg])
    UserSession.create(@user, true)
    if session[:allowed_beta].blank?
      session[:allowed_beta] = true
    end
    redirect_to choose_album_group_url(@user.groups.current_group)
  end
  
  def delete_member
    main_page_cred
    if params[:member_ids]
      unless params[:member_ids].size == current_user.groups.current_group.members.size
        Member.delete_all(:id => params[:member_ids])
        Membership.delete_all(:member_id => params[:member_ids])
        flash[:notice] = "Successfully deleted members."
      else
        flash[:notice] = "Deleting all members is not allowed."
      end
    else
      flash[:notice] = "Please select members to be deleted."
    end
    redirect_to remove_group_url(current_user.groups.current_group)
  end

  def deactivate
    @group.is_deactivated = true
    @group.save
    redirect_to root_url
  end
end