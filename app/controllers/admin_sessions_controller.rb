class AdminSessionsController < ApplicationController
  skip_before_filter :check_private_beta
  def new
    @admin_session = AdminSession.new
  end

  def create
    @admin_session = AdminSession.new(params[:admin_session])
    if @admin_session.save
      # flash[:notice] = "Successfully logged in!"
      # redirect_to admin_url
      redirect_to dashboards_url
    else
      # render :action => 'new'
      redirect_to admins_url, :notice => 'Incorrect username/password'
    end
  end

  def destroy
    @admin_session = AdminSession.find(params[:id])
    @admin_session.destroy
    # flash[:notice] = "Successfully logout!"
    redirect_to admins_url
  end
end
