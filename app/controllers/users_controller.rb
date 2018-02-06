class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :find_user, only: [:edit, :show, :update, :destroy]
  before_action :load_genders, only: %i(new create edit update)
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.activated.paginate page: params[:page],
      per_page: Settings.page_limit.number
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if user.save
      create_success
    else
      render :new
    end
  end

  def edit; end

  def update
    if user.update_attributes user_params
      flash[:success] = t ".update_success"
      redirect_to user
    else
      render :edit
    end
  end

  def destroy
    if user.destroy
      flash[:success] = t "destroy_success"
      redirect_to root_path
    else
      flash[:danger] = t ".cannot_destroy"
      redirect_to users_path
    end
  end

  def show
    redirect_to root_url && return unless user.activated?
    user_relationsip = current_user.active_relationships
    @relation_do =
      if current_user.following? user
        user_relationsip.find_by followed_id: user.id
      else
        user_relationsip.build
      end
    @microposts = user.feed params[:page]
  end

  private

  attr_reader :user

  def user_params
    params.require(:user).permit :firstname, :lastname,
      :age, :gender,
      :displayname, :email, :password,
      :password_confirmation
  end

  def correct_user
    redirect_to root_path unless user.current_user? current_user
  end

  def load_genders
    @genders = User.sexes.map{|key, value| [I18n.t("sex.#{key}"), value]}
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

  def find_user
    return if (@user = User.find_by id: params[:id])
    flash[:danger] = t ".find_user_fail"
    redirect_to root_path
  end

  def create_success
    user.send_activation_email
    flash[:info] = t ".check_email"
    redirect_to root_path
  end
end
