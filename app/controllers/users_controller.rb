class UsersController < ApplicationController
  before_action :move_to_login, only: %i[edit update favorite favorite_slideshow], unless: :user_signed_in?
  before_action :set_user, except: %i[favorite favorite_show favorite_slideshow]
  before_action :set_search, only: %i[show slideshow]
  before_action :set_favorite_search, only: %i[favorite favorite_slideshow]
  before_action :correct_user?, only: %i[edit update]
  before_action :set_picture, only: %i[post_show favorite_show]
  before_action :set_category, only: %i[post_show favorite_show]
  before_action :set_tags, only: %i[post_show favorite_show]
  before_action :set_comments, only: %i[post_show favorite_show]

  def show
    @pictures = @q.result(distinct: true).page(params[:page]).per(20)
  end

  def slideshow
    @pictures = @q.result(distinct: true).page(params[:page]).per(10)
  end

  def edit;end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "変更を保存しました"
    else
      render :edit
    end
  end

  def favorite
    @pictures = @q.result(distinct: true).page(params[:page]).per(20)
  end

  def favorite_slideshow
    @pictures = @q.result(distinct: true).page(params[:page]).per(10)
  end

  def following
    @users = @user.follow_users.includes(:pictures).order("relationships.created_at DESC").page(params[:page]).per(20)
  end

  def follower
    @users = @user.follower_users.includes(:pictures).order("relationships.created_at DESC").page(params[:page]).per(20)
  end

  def post_show
    @pictures = @user.pictures
    set_prev_and_next_picture
  end

  def favorite_show
    @pictures = current_user.favorite_pictures.order("favorites.created_at ASC")
    set_prev_and_next_picture
  end

  private

  def move_to_login
    flash[:alert] = "ログインが必要です"
    redirect_to new_user_session_path
  end

  def set_user
    @user = User.find(params[:id])
  end

  def set_search
    @params = search_params
    @q = @user.pictures.ransack(@params)
  end

  def set_favorite_search
    @params = search_params
    @q = current_user.favorite_pictures.ransack(@params)
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

  def set_tags
    @tag_list = @picture.tags.pluck(:name).join(",")
    @all_tags = Tag.pluck(:name)
  end

  def set_comments
    @comment = Comment.new
    @comments = @picture.comments.includes(:user).order("id DESC").page(params[:page]).per(10)
  end

  def set_prev_and_next_picture
    @index = @pictures.index(@picture)
    @previous = @pictures[@index + 1]
    @next = @pictures[@index - 1] if @index != 0
    @count = @pictures.index(@picture) + 1
  end

  def search_params
    if params[:q].present?
      params.require(:q).permit(:sorts)
    else
      params[:q] = { sorts: 'id desc' }
    end
  end

end