class UsersController < ApplicationController
  before_action :move_to_login, only: %i[edit update], unless: :user_signed_in?
  before_action :set_user, except: %i[favorite favorite_show]
  before_action :correct_user?, only: %i[edit update]
  before_action :set_picture, only: %i[post_show popular_show favorite_show]
  before_action :set_category, only: %i[post_show popular_show favorite_show]

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
    @users = @user.follow_users.includes(:pictures).page(params[:page]).per(20)
  end

  def follower
    @users = @user.follower_users.includes(:pictures).page(params[:page]).per(20)
  end

  def post_show
    @pictures = @user.pictures
    @previous = @pictures.where("id > ?", @picture.id).order("id ASC").first
    @next = @pictures.where("id < ?", @picture.id).order("id DESC").first
    @count = @pictures.index(@picture) + 1
  end

  def popular_show
    @pictures = @user.pictures.where("favorites_count > ?", 0).order("favorites_count ASC").order("id ASC")
    @index = @pictures.index(@picture)
    @previous = @pictures[@index + 1]
    @next = @pictures[@index - 1] if @index != 0
    @count = @pictures.index(@picture) + 1
  end

  def favorite_show
    @pictures = current_user.favorite_pictures.order("favorites.created_at ASC")
    @index = @pictures.index(@picture)
    @previous = @pictures[@index + 1]
    @next = @pictures[@index - 1] if @index != 0
    @count = @pictures.index(@picture) + 1
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

  def set_picture
    @picture = Picture.find(params[:picture_id])
  end

  def set_category
    @category = @picture.category
    @category_links = @category.siblings
  end

end