class NotificationsController < ApplicationController
  before_action :move_to_login, unless: :user_signed_in?

  def index
    @notifications = current_user.passive_notifications.includes(:visitor, :visited, :picture).page(params[:page]).per(10)
    @notifications.where(checked: false).each do |notification|
      notification.update_attributes(checked: true)
    end
  end

  def move_to_login
    flash[:alert] = "ログインが必要です"
    redirect_to new_user_session_path
  end

end