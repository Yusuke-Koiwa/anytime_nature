class UsersController < ApplicationController
  before_action :set_user

  def show
    @pictures = @user.pictures.order("created_at DESC").page(params[:page]).per(20)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

end