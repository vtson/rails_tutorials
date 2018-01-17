class UsersController < ApplicationController
  attr_reader :user

  def new
    @user = User.new
    gender
  end

  def create
    @user = User.new user_params
    if user.save
      flash[:success] = t "usercontroller.ttnewuser"
      redirect_to user
    else
      render :new, gender: gender
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
    @gender ||= gender_options
  end

  def gender_options
    User.sexes.map{|key, value| [I18n.t("signup.sex.#{key}"), value]}
  end
end
