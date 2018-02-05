class MicropostsController < ApplicationController
  attr_reader :micropost
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    if micropost.save
      flash[:success] = t ".micro_created"
      redirect_to root_path
    else
      @feed_items = current_user.feed params[:page]
      render "static_pages/home"
    end
  end

  def destroy
    if micropost.destroy
      flash[:success] = t ".micro_delete"
      redirect_to request.referer || root_url
    else
      flash[:danger] = t ".delete_fail"
      redirect_to root_path
    end
  end

  private

  def micropost_params
    params.require(:micropost).permit :content, :picture
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if micropost
    flash[:danger] = t ".not_correct"
    redirect_to root_path
  end
end
