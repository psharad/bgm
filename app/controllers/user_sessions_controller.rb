class UserSessionsController < ApplicationController
  def new
    @user_session = UserSession.new
    main_page_cred
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      redirect_to root_url
    else
      if mobile_device?
        render :action => 'new'
      else
        redirect_to login_url(:err => 1)
      end
    end
  end

  def destroy
    @user_session = UserSession.find(params[:id])
    @user_session.destroy rescue nil

    session.delete :user_step rescue nil

    if mobile_device?
      redirect_to root_url
    else
      redirect_to login_url
    end
  end
end
