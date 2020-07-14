class CommentsController < ApplicationController
  before_action :move_to_login, unless: :user_signed_in?
  before_action :set_comment, only: :destroy

  def create
    @picture = Picture.find(params[:picture_id])
    @comment = @picture.comments.build(comment_params)
    @comment.save
    @comment.picture.create_notification_comment(current_user, @comment.id)
    @comments = @comment.picture.comments.includes(:user).order("created_at DESC").page(params[:page]).per(10)
  end

  def destroy
    @comment.destroy
    @comments = @comment.picture.comments.includes(:user).order("created_at DESC").page(params[:page]).per(10)
  end

  private
  
  def move_to_login
    flash[:alert] = "ログインが必要です"
    redirect_to new_user_session_path
  end

  def comment_params
    params.require(:comment).permit(:text).merge(user_id: current_user.id)
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

end