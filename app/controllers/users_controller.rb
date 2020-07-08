class UsersController < ApplicationController
  before_action :move_to_login, only: %i[edit update], unless: :user_signed_in?
  before_action :set_user, except: :favorite
  before_action :correct_user?, only: %i[edit update]

  def show
    @pictures = @user.pictures.order("created_at DESC").page(params[:page]).per(20)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "変更を保存しました"
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  def popular
    @pictures = @user.pictures.where("favorites_count > ?", 0).order("favorites_count DESC").order("created_at DESC").page(params[:page]).per(20)
  end

  def favorite
    @pictures = current_user.favorite_pictures.order("favorites.created_at DESC").page(params[:page]).per(20)
  end

  def following
    @users = @user.follow_users.includes(:pictures)
  end

  def follower
    @users = @user.follower_users.includes(:pictures)
  end

  private

  def move_to_login
    flash[:alert] = "ログインが必要です"
    redirect_to new_user_session_path
  end

  def set_user
    @user = User.find(params[:id])
  end

  def correct_user?
    return if @user == current_user || current_user.admin?

    flash[:alert] = "権限がありません"
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit(:name, :image)
  end

end