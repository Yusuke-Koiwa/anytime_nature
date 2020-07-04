class PicturesController < ApplicationController
  before_action :move_to_login, except: %i[index, show], unless: :user_signed_in?

  def index
    @pictures = Picture.all
  end

  def new
    @picture = Picture.new
  end

  def create
    @picture = Picture.new(picture_params)
    if @picture.save
      redirect_to pictures_path, notice: "写真を投稿しました"
    else
      redirect_to new_picture_path, alert: "必須項目を全て入力して下さい"
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