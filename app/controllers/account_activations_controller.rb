class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if user && !user.activated? && (user_authenticate user)
      active_account user
    else
      flash[:danger] = t ".edit.invalid_link"
      redirect_to root_url
    end
  end

  private

  def active_account user
    user.activate
    log_in user
    flash[:success] = t ".edit.active_account"
    redirect_to user
  end

  def user_authenticate user
    user.authenticated?(:activation, params[:id])
  end
end
