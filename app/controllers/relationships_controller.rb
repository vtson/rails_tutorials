class RelationshipsController < ApplicationController
  attr_reader :user
  before_action :logged_in_user, only: %i(create destroy)
  before_action :find_user, only: %i(action_follow)

  def create
    @user = User.find_by id: params[:followed_id]
    current_user.follow user
    @relation_do =
      current_user.active_relationships.find_by followed_id: user.id
    do_respond
  end

  def destroy
    @user = Relationship.find_by(id: params[:id]).followed
    current_user.unfollow user
    @relation_do = current_user.active_relationships.build
    do_respond
  end

  def action_follow
    action = request.path.split("/").last
    @title = t ".#{action}"
    @users = user.send(action).paginate page: params[:page],
      per_page: Settings.per_page
    render "users/show_follow"
  end

  private

  def do_respond
    respond_to do |format|
      format.html{redirect_to user}
      format.js
    end
  end

  def find_user
    return if (@user = User.find_by id: params[:id])
    flash[:danger] = t ".find_user_fail"
    redirect_to root_path
  end
end
