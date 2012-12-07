class HomesController < ApplicationController
  skip_before_filter :check_private_beta, :only => [:about, :terms_of_use]
  before_filter :logged_in, :only => :show
  def index
    session.delete :user_step
    session.delete :user_params
    @user_session = UserSession.new
    main_page_cred
  end

  def soon
    render :layout => 'application'
  end

  def show
    # @client = Grackle::Client.new(:auth => {
    #    :type => :oauth,
    #    :consumer_key => TWITTER[:consumer_key], 
    #    :consumer_secret => TWITTER[:consumer_secret],
    #    :token => session[:ta_token], 
    #    :token_secret => session[:ta_secret_token]
    # })
    # @tweets = @client.statuses.mentions?(:count => 3, :include_entities => true) rescue []
    main_page_cred
  end
  
  def terms
    render :layout => false
  end
  
  def privacy
    render :layout => false
  end
  
  def terms_of_use
    main_page_cred
  end
  
  def about
    main_page_cred
    @bloggers = Admin.find(:all, :conditions => {:blogger => true})
  end

  def local_offers
    @local_offers = LocalOffer.find(:all).paginate(:page => params[:page], :per_page => 7)
  end

  def local_offer
    @local_offer  = LocalOffer.find(params[:id])
  end
  
  def more_tweets
    require 'twitter'
    
    @tweets = Twitter.user_timeline('connectingsexes', :include_rts => true, :page => params[:page])
    respond_to do |format|
      format.js {@page = params[:page].to_i + 1} 
    end

  end
end
