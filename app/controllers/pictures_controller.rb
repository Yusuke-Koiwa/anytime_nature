class PicturesController < ApplicationController
  before_action :move_to_login, except: %i[index, show], unless: :user_signed_in?

  def index
    @pictures = Picture.all
  end

  def new
    @picture = Picture.new
    @parent_categories = Category.where(ancestry: nil)
  end

  def create
    @picture = Picture.new(picture_params)
    if @picture.save
      redirect_to pictures_path, notice: "写真を投稿しました"
    else
      render :new
    end
  end

  private
  def move_to_login
    flash[:alert] = "ログインが必要です"
    redirect_to new_user_session_path
  end

  def picture_params
    params.require(:picture).permit(:title, :image, :category_id).merge(user_id: current_user.id)
  end

end