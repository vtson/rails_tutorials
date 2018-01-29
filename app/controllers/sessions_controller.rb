class SessionsController < ApplicationController
  def new; end

  def create
    params_session = params[:session]
    user = User.find_by email: params_session[:email].downcase
    if user && user.authenticate(params_session[:password])
      if user.activated?
        login_user user
      else
        user_non_active
      end
    else
      login_fail
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def login_user user
    log_in user
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
    redirect_back_or user
  end

  def user_non_active
    message = t ".create.acc_active"
    flash[:warning] = message
    redirect_to root_path
  end

  def login_fail
    flash[:danger] = t ".new.invalid"
    render :new
  end
end
