class RelationshipsController < ApplicationController
  before_action :move_to_login, unless: :user_signed_in?
  before_action :set_user

  def create
    current_user.follow(@user)
  end

  def destroy
    current_user.unfollow(@user)
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def move_to_login
    flash[:alert] = "ログインが必要です"
    redirect_to new_user_session_path
  end
end