class MembersController < ApplicationController
  before_filter :logged_in
  before_filter :group_checker
  before_filter :members_email, :only => [:new, :create, :email_value, :search_by_email, :edit_search_by_email]
  # GET /members
  # GET /members.xml
  def index
    @members = Member.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @members }
    end
  end

  # GET /members/1
  # GET /members/1.xml
  def show
    main_page_cred
    @member = Member.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @member }
    end
  end

  # GET /members/new
  # GET /members/new.xml
  def new
    main_page_cred
    begin
      @group = Group.find(params[:group_id])
    rescue
      slug = Slug.find_by_name(params[:group_id])
      @group = Group.find(slug.sluggable_id)
    end
    
    if (@group.size > params[:mpos].to_i)
      @can_add = (@group.size > params[:mpos].to_i + 1) || (@group.size > (@group.members.size + 2)) # new member record + group leader
      position = @group.members.size
      @member = @group.members.find_by_position(params[:mpos]) || @group.members.build(:position => position + 1)
      @member.save(false)
      memship = @member.memberships.find_or_initialize_by_group_id_and_user_id(@group.id, current_user.id, :token => Digest::SHA1.hexdigest([Time.now, rand].join)[1..20])
      memship.save
    end
    # @can_add = true
    # @membership = Membership.find_all_by_group_id(@group.id)
    # if (@membership.count.to_i + 1) >= @group.size
    #   @can_add = false
    # end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @member }
    end
  end
  
  def add
    main_page_cred
    @group = current_user.groups.current_group
    @member = @group.members.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @member }
    end
  end

  # GET /members/1/edit
  def edit
    main_page_cred
    @member = Member.find(params[:id])
  end

  # POST /members
  # POST /members.xml
  def create
    main_page_cred
    begin
      @group = Group.find(params[:group_id])
    rescue
      slug = Slug.find_by_name(params[:group_id])
      @group = Group.find(slug.sluggable_id)
    end
    
    @can_add = (@group.size > params[:mpos].to_i + 1) || (@group.size > (@group.members.size + 1)) # + group leader
    @member = @group.members.find_by_position(params[:mpos])
    @member.memberships.find_or_initialize_by_group_id_and_user_id(@group.id, current_user.id, :token => Digest::SHA1.hexdigest([Time.now, rand].join)[1..20])
    @member.update_attributes(params[:member])
    
    respond_to do |format|
      unless current_user.groups.current_group.members.map(&:email).count(@member.email) > 1
        if @member.save
          format.html { @can_add ? redirect_to(new_group_member_path(@group, rbtokenizer.merge(:mpos => @member.position.next))) : redirect_to(group_preferences_url(@group)) }
          format.xml  { render :xml => @member, :status => :created, :location => @member }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @member.errors, :status => :unprocessable_entity }
        end
      else
        @member.errors.add_to_base('Email already added to this group.')
        format.html { render :action => "new" }
        format.xml  { render :xml => @member.errors, :status => :unprocessable_entity }
      end  
    end
  end

  def save_added
    main_page_cred
    @group = current_user.groups.current_group
    @member = @group.members.build(params[:member])
    @member.memberships.build(:group_id => @group.id, :user_id => current_user.id, :token => Digest::SHA1.hexdigest([Time.now, rand].join)[1..20])    
    
    respond_to do |format|
      unless current_user.groups.current_group.members.map(&:email).include?(@member.email)
        if @member.save
          # if current_user.groups.current_group.members.all(:select => 'distinct sex').first.sex == "Women"
          #   gender = "Women"
          # elsif current_user.groups.current_group.members.all(:select => 'distinct sex').first.sex == "Men"
          #   gender = "Men"
          # else
          #   gender = "Mixed"
          # end
          current_user.groups.current_group.update_attributes(:size => current_user.groups.current_group.size+1)
          flash[:notice] = 'Member was successfully created.'
        
          format.html { redirect_to(edit_group_url(@group)) }
          format.xml  { render :xml => @member, :status => :created, :location => @member }
        else
          format.html { render :action => "add" }
          format.xml  { render :xml => @member.errors, :status => :unprocessable_entity }
        end
      else
        @member.errors.add_to_base('Email already added to this group.')
        format.html { render :action => "add" }
        format.xml  { render :xml => @member.errors, :status => :unprocessable_entity }
      end
    end
  end
  # PUT /members/1
  # PUT /members/1.xml
  def update
    main_page_cred
    @member = Member.find(params[:id])
    if params[:lf]
      path = group_preferences_url(current_user.groups.current_group)
    else
      path = :back
    end
    respond_to do |format|
      if @member.update_attributes(params[:member])
        format.html { redirect_to(path, :notice => 'Member was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @member.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /members/1
  # DELETE /members/1.xml
  def destroy
    @member = Member.find(params[:id])
    @member.destroy

    respond_to do |format|
      format.html { redirect_to(members_url) }
      format.xml  { head :ok }
    end
  end
  
  def group_checker
    unless current_user.groups
      redirect_to root_url
    end
  end
  
  def email_value
    render :json => @email.to_json
  end
  
  def edit_search_by_email
    @member_value = Member.find_by_email(params[:email])
    @group = current_user.groups.current_group
    @member = @group.members.build
  end
  
  def search_by_email
    @member_value = Member.find_by_email(params[:email])
    @group = current_user.groups.current_group
    @member = @group.members.build(params[:member])
    @member.memberships.build(:group_id => @group.id, :user_id => current_user.id, :token => Digest::SHA1.hexdigest([Time.now, rand].join)[1..20])
    @membership = current_user.groups.current_group.memberships
    @can_add = (@group.size > (@group.members.size + 1))
    
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def members_email
    @email = current_user.members.all(:select => :email, :conditions => "email <> ''").map(&:email) rescue nil
  end
  
  def edit_check
    redirect_to edit_group_member_url(current_user.groups.current_group, params[:id])
  end
end
