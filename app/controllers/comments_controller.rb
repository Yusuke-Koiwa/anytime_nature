class CommentsController < ApplicationController
  before_action :move_to_login, unless: :user_signed_in?

  def create
    @picture = Picture.find(params[:picture_id])
    @comment = @picture.comments.build(comment_params)
    @comment.save
    @comments = @comment.picture.comments
  end

  private
  
  def move_to_login
    flash[:alert] = "ログインが必要です"
    redirect_to new_user_session_path
  end

  def comment_params
    params.require(:comment).permit(:text).merge(user_id: current_user.id)
  end

end