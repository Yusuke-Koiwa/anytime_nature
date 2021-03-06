class PicturesController < ApplicationController
  before_action :move_to_login, except: %i[index show slideshow], unless: :user_signed_in?
  before_action :set_search, only: %i[index slideshow]
  before_action :set_picture, only: %i[show update destroy]
  before_action :correct_user?, only: %i[update destroy]
  before_action :set_all_tags, only: %i[new show]

  def index
    @pictures = @q.result(distinct: true).page(params[:page]).per(20)
  end

  def slideshow
    @pictures = @q.result(distinct: true).page(params[:page]).per(10)
  end

  def show
    @category = @picture.category
    @tag_list = @picture.tags.pluck(:name).join(",")
    @comment = Comment.new
    @comments = @picture.comments.includes(:user).order("id DESC").page(params[:page]).per(10)
  end

  def new
    @picture = Picture.new
    @parents = Category.where(ancestry: nil)
  end

  def create
    @picture = Picture.new(picture_params)
    tag_list = params[:tag_list].split(",") if params[:tag_list].present?
    if @picture.save
      @picture.save_tags(tag_list) if tag_list.present?
      redirect_to root_path, notice: "写真を投稿しました"
    else
      redirect_to new_picture_path, alert: "写真投稿が正常に行われませんでした"
    end
  end

  def update
    if params[:tag_list].present?
      tag_list = params[:tag_list].split(",")
      @picture.save_tags(tag_list)
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @picture.destroy
    redirect_to root_path, notice: "写真を削除しました"
  end

  private
  def move_to_login
    flash[:alert] = "ログインが必要です"
    redirect_to new_user_session_path
  end

  def set_search
    @params = search_params
    @q = Picture.ransack(@params)
  end

  def set_picture
    @picture = Picture.find(params[:id])
  end
  
  def correct_user?
    return if @picture.user == current_user || current_user.admin?

    flash[:alert] = "権限がありません"
    redirect_to root_path
  end

  def picture_params
    params.require(:picture).permit(:image, :category_id).merge(user_id: current_user.id)
  end

  def set_all_tags
    @all_tags = Tag.pluck(:name)
  end

  def search_params
    if params[:q].present?
      params.require(:q).permit(:tags_name_cont, :sorts)
    else
      params[:q] = { sorts: 'id desc' }
    end
  end

end