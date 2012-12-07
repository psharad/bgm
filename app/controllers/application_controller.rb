require 'net/http'
require 'uri'
require 'cgi'

class ApplicationController < ActionController::Base
  ############################################################
  # ERROR HANDLING et Foo
  include ExceptionNotification::ExceptionNotifiable
  #Comment out the line below if you want to see the normal rails errors in normal development.
  # alias :rescue_action_locally :rescue_action_in_public if Rails.env == 'development'
  self.error_layout = false
  self.exception_notifiable_noisy_environments = ["staging", "production"]
  self.exception_notifiable_verbose = true #SEN uses logger.info, so won't be verbose in production
  self.exception_notifiable_pass_through = :hoptoad # requires the standard hoptoad gem to be installed, and setup normally
  self.exception_notifiable_silent_exceptions = [Acl9::AccessDenied, MethodDisabled, ActionController::RoutingError ]
  #specific errors can be handled by something else:
  rescue_from 'Acl9::AccessDenied', :with => :access_denied
  # rescue_from 'ActionController::RoutingError', :with => :access_denied
  # END ERROR HANDLING
  ############################################################

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  filter_parameter_logging :password

  helper_method :current_admin_session, 
                :current_admin, 
                :current_user_session, 
                :current_user, 
                :oauth_link, 
                :fb_logged_in, 
                :tw_logged_in, 
                :current_fb_session, 
                :mobile_device?, 
                :apple_device?, 
                :android_device?,
                :chrome?, 
                :rbtokenizer, 
                :main_page_cred,
                :fb_connect_link,
		            :not_current_fb_user_link

  # before_filter :check_private_beta

  uses_tiny_mce :options => { :theme => 'advanced' , 
                              :theme_advanced_toolbar_location => 'top', 
                              :theme_advanced_toolbar_align => 'left', 
                              :theme_advanced_buttons1 => 'bold,italic,underline,strikethrough,separator,fontselect,fontsizeselect,separator,justifyleft,justifycenter,justifyright,justifyfull,separator,bullist,numlist,image,code',
                              :theme_advanced_buttons2 => 'pastetext, pasteword, selectall',
                              :theme_advanced_buttons3 => '',
                              :height => "250",
                              :width => "600",
                              :paste_auto_cleanup_on_paste => true,
                              :paste_convert_headers_to_strong => true,
                              :plugins => %w{paste}}

  def check_private_beta
    beta = BetaKey.find(1).beta_key
    if !params[:code].nil? && params[:code] == beta
      session[:allowed_beta] = true
    end
    if !params[:code].nil? && params[:code] == "secret"
      session[:allowed_beta] = true
    end
    if session[:allowed_beta].blank?
      redirect_to beta_pages_url
    end
  end

  def homepage
    unless current_user
      if mobile_device?
        redirect_to main_url
      else
        redirect_to new_user_path(:from=>"root")
      end
    else
      redirect_to home_url
    end
  end

  def rbtokenizer
    {:rbtoken => current_user.try(:rollback_token) || params[:token]}
  end

  def http_domain
   return root_url.slice(0,(root_url.size-1))
  end

  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
  
  def current_admin_session
    return @current_admin_session if defined?(@current_admin_session)
    @current_admin_session = AdminSession.find
  end

  def current_admin
    return @current_admin if defined?(@current_admin)
    @current_admin = current_admin_session && current_admin_session.record
  end
  
  def require_admin
    unless current_admin
      # store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_admin_session_url
      return false
    end
  end

  def fb_logged_in(access_token=nil)
    @fb_logged_in = access_token.present?
    begin
      @fb = current_fb_session(access_token).me
    rescue
      @fb_logged_in = false
    end
  end

  def tw_logged_in
    @twitter_access_token = cookies[:twitter_access_token]
    @tw_logged_in = @twitter_access_token.present?
  end

  def oauth_link
    if request.user_agent =~/Mobile/
      display = :touch
    else
      display = :popup
    end
    beta = BetaKey.find(1).beta_key
    MiniFB.oauth_url(Facebook::Settings.fb_app_id,
                     Facebook::Settings.host + "/facebook_sessions/create?lg=#{current_user.id}&code=#{beta}",
                     :scope  => Facebook::Settings.permissions.join(","),
                     :display => display)  
  end
  
  def current_fb_session(access_token=nil)
    @_current_session ||= MiniFB::OAuthSession.new(access_token, 'en_US')
  end
  
  def fb_connect_link
    MiniFB.oauth_url(Facebook::Settings.fb_app_id,
                     Facebook::Settings.host + "/facebook_sessions/get_fb_info?spid=#{get_sp}",
                     :scope  => Facebook::Settings.permissions2.join(","))  
  end
  
  def logged_in    
    unless current_user
      flash[:notice] = "You must be logged in to access this page"
      redirect_to root_url
    end
  end
  
  def admin_access
    unless current_admin
      flash[:notice] = "You must have admin access to view this page"
      redirect_to root_url
    end    
  end
  
  def mobile_device?
    request.user_agent =~/iPhone|iPod|Android/
  end

  def apple_device?
    request.user_agent =~/iPhone|iPod/
  end

  def android_device?
    request.user_agent =~/Android/
  end

  def chrome?
    request.user_agent =~/Chrome/
  end

  def safari?
    request.user_agent =~/Safari/
  end

  
  def main_page_cred
    begin
      require 'twitter'
      #@client       ||= TwitterSearch::Client.new('connectingsexes')
      #@tweets       ||= @client.query(:q => 'connectingsexes', :rpp => '5')
      
      #YOUR_CONSUMER_KEY = '6P4QBbcAyj45CdFLQ83pw'
      #YOUR_CONSUMER_SECRET = 'GYbYxtML1dFrof7KbW9tJGN0DRejCYnAvWhIOSFjU'
      #YOUR_OAUTH_TOKEN = '309668987-aHRVmAt2cgAxn6NV9scGP0HfvuCdMECfudkRQqXR'
      #YOUR_OAUTH_TOKEN_SECRET = 'wCI4fW8tKfVSPZc425rsklk7Rg9vDd3lGFhUEIw8'

      #Twitter.configure do |config|
      #  config.consumer_key = '6P4QBbcAyj45CdFLQ83pw'
      #  config.consumer_secret = 'GYbYxtML1dFrof7KbW9tJGN0DRejCYnAvWhIOSFjU'
      #  config.oauth_token = '309668987-aHRVmAt2cgAxn6NV9scGP0HfvuCdMECfudkRQqXR' 
      #  config.oauth_token_secret = 'wCI4fW8tKfVSPZc425rsklk7Rg9vDd3lGFhUEIw8' 
      #end
       
      # Twitter.user('connectingsexes')
      # @user_timeline = Twitter.user_timeline('connectingsexes', :include_rts => true)
      # #@tweets = Twitter.home_timeline
      # @search = Twitter.search('connectingsexes')
      # 
      # tweets = (@search + @user_timeline).compact
      # 
      # @tweets = tweets.inject([]) do |result, item|
      #   result << item unless result.map(&:id).include?(item.id)
      #   result
      # end
      # 
      # @tweets = @tweets.sort! {|a,b| Time.parse(b.created_at).to_i <=> Time.parse(a.created_at).to_i}
      
      @tweets = TweetData.all.map(&:tdata)
      
    rescue
      @tweets = []
      @images       ||= Image.find(:all, :order => 'created_at DESC')
    end
    @images       ||= Image.find(:all, :order => 'created_at DESC')
  end
  
  def http_get(domain,path,params)
    return Net::HTTP.get(domain, "#{path}?".concat(params.collect { |k,v| "#{k}=#{CGI::escape(v.to_s)}" }.join('&'))) if not params.nil?
    return Net::HTTP.get(domain, path)
  end

  def not_current_fb_user_link
    # @_current_session.rest("logout",  :callback => Facebook::Settings.host + "/facebook_sessions/get_fb_info" )
    # redirect_to 
  end

  def get_sp
    session[:sp_id] ? session[:sp_id] : cookies[:sp_id]
  end
  
  def set_sp!(sp)
    session[:sp_id] = sp.to_s
    cookies[:sp_id] = { :value => sp.to_s, :expires => 1.hour.from_now }
  end
  
  def del_sp!
    session.delete :sp_id
    cookies.delete :sp_id
  end
  
  def transliterate(str)
    # Based on permalink_fu by Rick Olsen

    # Escape str by transliterating to UTF-8 with Iconv
    s = Iconv.iconv('ascii//ignore//translit', 'utf-8', str).to_s

    # Downcase string
    s.downcase!

    # Remove apostrophes so isn't changes to isnt
    s.gsub!(/'/, '')

    # Replace any non-letter or non-number character with a space
    s.gsub!(/[^A-Za-z0-9]+/, ' ')

    # Remove spaces from beginning and end of string
    s.strip!

    # Replace groups of spaces with single hyphen
    s.gsub!(/\ +/, '-')

    return s
  end
  
  def transliterate_file_name
    extension = File.extname(local_file_name).gsub(/^\.+/, '')
    filename = local_file_name.gsub(/\.#{extension}$/, '')
    self.local.instance_write(:file_name, "#{transliterate(filename)}.#{transliterate(extension)}")
  end
  
  
end
