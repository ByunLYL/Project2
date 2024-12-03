class SessionsController < ApplicationController
  def new
  end

  def create
    if user = login(params[:email], params[:password])
      update_browser_uuid user.uuid

      flash[:notice] = "login successfully"
      redirect_to root_path
    else
      flash[:notice] = "The email address or password is incorrect"
      redirect_to new_session_path
    end
  end

  def destroy
    logout
    cookies.delete :user_uuid
    flash[:notice] = "Exit successfully"
    redirect_to root_path
  end
end
