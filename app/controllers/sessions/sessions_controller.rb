class Sessions::SessionsController < Devise::SessionsController
  def guest_login
    user = User.guest
    sign_in user
    redirect_to root_path, notice: 'ゲストユーザーとしてログインしました。'
  end
end