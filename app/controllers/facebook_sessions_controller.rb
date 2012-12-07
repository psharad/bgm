# require 'logger'

class FacebookSessionsController < ApplicationController
  skip_before_filter :check_private_beta
  
  def new
  end
  
  def get_fb_info
    set_sp!(params[:spid]) unless params[:spid].blank?
    errcode = params[:error]
    if !errcode.nil?    
      redirect_to choose_method_facebook_url(:code => "secret", :err => errcode)
    else
      begin
        sp = SetupParams.find(get_sp)
        code = params[:code]
        access_token_hash = MiniFB.oauth_access_token(Facebook::Settings.fb_app_id, 
                                                  Facebook::Settings.host + "/facebook_sessions/get_fb_info?spid=#{sp.id}", 
                                                  Facebook::Settings.fb_secret, code)
        sp.update_attribute(:access_token, access_token_hash["access_token"])
        if session[:reg_flow].eql?("manual")
          sp.update_attributes(:fb_ids => {"0" => current_fb_session(sp.access_token).me.id})
          redirect_to group_upload_photo_url(:code => "secret")
        else
          redirect_to new_leader_profile_url(:code => "secret", :sp => sp.id.to_s)
        end
      rescue Exception => exc
        redirect_to new_leader_profile_url(:code => "secret", :sp => sp.id.to_s, :err => exc.message)
      end
    end
  end
  
  def create
    # logger_d = Logger.new('log/cs_debug.log', 'daily')
    user = params[:lg]
    begin
      # logger_d.debug 'session before fb'
      # logger_d.debug session
      # logger_d.debug 'cookies before fb'
      # logger_d.debug cookies
      # logger_d.debug 'current user'
      # logger_d.debug current_user
      code = params[:code]
      if code
        access_token_hash = MiniFB.oauth_access_token(Facebook::Settings.fb_app_id, 
                                                      Facebook::Settings.host + "/facebook_sessions/create?lg=#{params[:lg]}", 
                                                      Facebook::Settings.fb_secret, code)
        access_token = access_token_hash["access_token"]
        cookies[:access_token] = access_token
        # logger_d.debug 'after fb'
        # logger_d.debug 'session'
        # logger_d.debug session
        # logger_d.debug 'cookies after fb'
        # logger_d.debug cookies
      end
      # logger_d.debug 'current user'
      # logger_d.debug current_user
      @group = Group.find(current_user.groups.current_group)
      # @group = Group.find(session[:group_id])
      unless session[:f]
        redirect_to choose_album_group_url(@group, :code => "secret")
      else
        redirect_to choose_album_group_url(@group, :f => session[:f], :code => "secret")
      end
    rescue
      redirect_to login_again_groups_url(:lg => user, :code => "secret")
    end
  end
end
