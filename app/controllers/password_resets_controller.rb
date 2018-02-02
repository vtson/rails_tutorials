class PasswordResetsController < ApplicationController
  attr_reader :user

  before_action :find_user, :valid_user,
    :check_expiration, only: [:edit, :update]

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if user
      send_email user
    else
      flash.now[:danger] = t ".not_email"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      user.errors.add :password, t(".not_empty")
    elsif user.update_attributes user_params
      update_success user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def find_user
    return if (@user = User.find_by email: params[:email].downcase)
    flash[:danger] = t ".find_fail"
    redirect_to root_path
  end

  def valid_user
    return if user_authentication
    redirect_to root_path
  end

  def check_expiration
    return unless user.password_reset_expired?
    flash[:danger] = t ".expried"
    redirect_to new_password_reset_url
  end

  def send_email user
    user.create_reset_digest
    user.send_password_reset_email
    flash[:info] = t ".send_email"
    redirect_to root_path
  end

  def update_success user
    user.update_attributes! reset_digest: nil
    flash[:success] = t ".update_success"
    redirect_to login_path
  end

  def user_authentication
    user && user.activated? && user.authenticated?(:reset, params[:id])
  end
end
