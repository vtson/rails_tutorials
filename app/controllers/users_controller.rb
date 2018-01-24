class UsersController < ApplicationController
  attr_reader :user

  before_action :gender, only: %i(new create)

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if user.save
      flash[:success] = t "usercontroller.ttnewuser"
      redirect_to user
    else
      render :new
    end
  end

  def show
    @user = User.find_by id: params[:id]
    redirect_to root_url, notice: t("find_user.notfind") unless user
  end

  private

  def user_params
    params.require(:user).permit :firstname, :lastname,
      :age, :gender,
      :displayname, :email, :password,
      :password_confirmation
  end

  def gender
    @gender = User.sexes.map{|key, value| [I18n.t("sex.#{key}"), value]}
  end
end
