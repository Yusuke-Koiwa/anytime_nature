class FavoritesController < ApplicationController
  before_action :move_to_login, unless: :user_signed_in?
  before_action :set_picture

  def create
    @favorite = current_user.create_favorite(@picture)
    @picture.reload
  end

  def destroy
    @favorite = current_user.delete_favorite(@picture)
    @picture.reload
  end

  private

  def set_picture
    @picture = Picture.find(params[:picture_id])
  end

  def move_to_login
    flash[:alert] = "ログインが必要です"
    redirect_to new_user_session_path
  end
end