class PicturesController < ApplicationController
  before_action :move_to_login, except: %i[index show], unless: :user_signed_in?
  before_action :set_picture, only: %i[show update destroy]
  before_action :correct_user?, only: %i[update destroy]

  def index
    @q = Picture.ransack(params[:q])
    @pictures = @q.result(distinct: true).order("created_at DESC").page(params[:page]).per(20)
  end

  def show
    @category = @picture.category
    @tag_list = @picture.tags.pluck(:name).join(",")
  end

  def new
    @picture = Picture.new
    @parents = Category.where(ancestry: nil)
  end

  def create
    @picture = Picture.new(picture_params)
    tag_list = params[:tag_list].split(",")
    if @picture.save
      @picture.save_tags(tag_list)
      redirect_to root_path, notice: "写真を投稿しました"
    else
      redirect_to new_picture_path, alert: "必須項目を全て入力して下さい"
    end
  end

  def update
    tag_list = params[:tag_list].split(",")
    @picture.save_tags(tag_list)
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

  
  def set_picture
    @picture = Picture.find(params[:id])
  end
  
  def correct_user?
    return if @picture.user == current_user || current_user.admin?

    flash[:alert] = "権限がありません"
    redirect_to root_path
  end

  def picture_params
    params.require(:picture).permit(:title, :image, :category_id).merge(user_id: current_user.id)
  end

end