require 'rails_helper'
describe NotificationsController do
  let(:user)          { create(:user) }
  let(:other)         { create(:user) }

  describe '#index' do
    context 'ログインしている場合' do
      before do
        login user
      end
      it '@notificationsに正しい値が入っている' do
        notifications = create_list(:notification, 3, visitor_id: other.id, visited_id: user.id, checked: true)
        get :index
        expect(assigns(:notifications)).to match(notifications.sort { |a, b| b.created_at <=> a.created_at} )
      end
      it 'notificationのcheckedがfalseの場合、trueに更新される' do
        notification = create(:notification, visitor_id: other.id, visited_id: user.id, checked: false)
        get :index
        expect(notification.reload.checked).to eq(true)
      end
      it 'index.html.hamlに遷移する' do
        get :index
        expect(response).to render_template :index
      end
    end

    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトする' do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end