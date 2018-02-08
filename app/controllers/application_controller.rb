class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  before_action :set_locale

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t ".require_login"
    redirect_to login_path
  end

  def find_user
    return if (@user = User.find_by id: params[:id])
    flash[:danger] = t ".find_user_fail"
    redirect_to user
  end
end
