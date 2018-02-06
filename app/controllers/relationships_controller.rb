class RelationshipsController < ApplicationController
  attr_reader :user, :title, :users
  before_action :logged_in_user, only: %i(create destroy)
  before_action :find_follower, only: :create
  before_action :find_unfollower, only: :destroy

  def create
    current_user.follow user
    @relation_do =
      current_user.active_relationships.find_by followed_id: user.id
    do_respond
  end

  def destroy
    current_user.unfollow user
    @relation_do = current_user.active_relationships.build
    do_respond
  end

  private

  def do_respond
    respond_to do |format|
      format.html{redirect_to user}
      format.js
    end
  end

  def find_follower
    return if (@user = User.find_by id: params[:followed_id])
    flash[:danger] = t ".find_user_fail"
    redirect_to root_path
  end

  def find_unfollower
    return if (@user = Relationship.find_by id: params[:id])
    flash[:danger] = t ".find_user_fail"
    redirect_to root_path
  end
end
