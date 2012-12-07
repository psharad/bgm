class TwitterSessionsController < ApplicationController
  skip_before_filter :check_private_beta, :only => [:catch]
  
  def new
    consumer = OAuth::Consumer.new(TWITTER[:consumer_key], TWITTER[:consumer_secret], {:site=>"http://twitter.com"})
    req_token = consumer.get_request_token(:oauth_callback => TWITTER[:host] + final_twitter_sessions_path(:lg => current_user.id))
    session[:request_token] = req_token.token
    session[:request_token_secret] = req_token.secret
    redirect_to req_token.authorize_url
  end
  
  def final
    begin
      consumer = OAuth::Consumer.new(TWITTER[:consumer_key], TWITTER[:consumer_secret], {:site=>"http://twitter.com"})
      req_token = OAuth::RequestToken.new(consumer, session[:request_token], session[:request_token_secret])
      cookies[:twitter_access_token] = access_token = req_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
      # session[:ta_token] = access_token.token
      # session[:ta_secret_token] = access_token.secret
      redirect_to root_url
    rescue
      flash[:notice] = 'Twitter log in fail. Please retry.'
      cookies.delete :twitter_access_token
      redirect_to catch_twitter_sessions_url(:lg => params[:lg])
    end
  end
  
  def catch
    @user = User.find(params[:lg])
    UserSession.create(@user, true)
    if session[:allowed_beta].blank?
      session[:allowed_beta] = true
    end
    flash[:notice] = "Twitter connect failed. Please try again"
    redirect_to root_url
  end
  
  def post
    client = Grackle::Client.new(:auth => {
       :type => :oauth,
       :consumer_key => TWITTER[:consumer_key], :consumer_secret => TWITTER[:consumer_secret],
       :token => "309668987-aHRVmAt2cgAxn6NV9scGP0HfvuCdMECfudkRQqXR", :token_secret => "wCI4fW8tKfVSPZc425rsklk7Rg9vDd3lGFhUEIw8"
     })
    client.statuses.update! :status => params[:tweet][:message]
    redirect_to root_url
  end
end