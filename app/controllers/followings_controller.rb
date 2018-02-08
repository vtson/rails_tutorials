class FollowingsController < ApplicationController
  attr_reader :user, :title, :users
  before_action :logged_in_user, :find_user, only: %i(index)

  def index
    @title = t ".title"
    @users = user.following.paginate page: params[:page],
      per_page: Settings.page_limit.number
    render "users/_show_follow",
      locals: {title: title, user: user, users: users}
  end
end
