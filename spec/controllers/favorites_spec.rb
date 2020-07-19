require 'rails_helper'

describe FavoritesController do
  let(:user)            { create(:user) }
  let(:other)           { create(:user) }
  let(:picture)         { create(:picture, user: other) }
  let(:create_params)   { { picture_id: picture.id } }
#--------------------------------------------------------------------------------
  describe "#create" do
    context "ログインしている場合" do
      before do
        login user
      end

      context '投稿をお気に入りしていない場合'do
        subject { post :create, xhr: true, params: create_params }
        it "favoriteを保存する" do
          expect { subject }.to change(Favorite, :count).by(1)
        end
        it '対象のpictureのfavorites_countが +1 される' do
          subject
          expect(picture.reload.favorites_count).to eq(1)
        end
        it "notificationを保存する" do
          expect { subject }.to change(Notification, :count).by(1)
        end
      end

      context '既に投稿をお気に入りしている場合' do
        subject { post :create, xhr: true, params: create_params }
        it "favoriteを保存しない" do
          create(:favorite, user: user, picture: picture)
          expect { subject }.not_to change(Favorite, :count)
        end
        it '対象のpictureのfavorites_countを加算しない' do
          create(:favorite, user: user, picture: picture)
          subject
          expect(picture.reload.favorites_count).to eq(1)
        end
        it "notificationを保存しない" do
          create(:notification, visitor_id: user.id, visited_id: other.id, action: "favorite", picture_id: picture.id)
          expect { subject }.not_to change(Notification, :count)
        end
      end
    end

    context "ログインしていない場合" do
      subject { post :create, xhr: true, params: create_params }
      it "favoriteを保存しない" do
        expect { subject }.not_to change(Favorite, :count)
      end
      it '対象のpictureのfavorites_countを加算しない' do
        subject
        expect(picture.reload.favorites_count).to eq(0)
      end
      it "notificationを保存しない" do
        expect { subject }.not_to change(Notification, :count)
      end
      it "ログインページに遷移する" do
        subject
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
#--------------------------------------------------------------------------------
  describe '#destroy' do
    context 'ログインしている場合' do
      before do
        login user
      end

      context '投稿をお気に入りしている場合' do
        it 'favoriteを削除する' do
          favorite = create(:favorite, user: user, picture: picture)
          delete_params = { id: favorite.id, picture_id: picture.id }
          expect do
            delete :destroy, xhr: true, params: delete_params
          end.to change(Favorite, :count).by(-1)
        end
        it '対象のpictureのfavorites_countが -1 される' do
          favorite = create(:favorite, user: user, picture: picture)
          delete_params = { id: favorite.id, picture_id: picture.id }
          delete :destroy, xhr: true, params: delete_params
          expect(picture.reload.favorites_count).to eq(0)
        end
      end

      context '投稿をお気に入りしていない場合' do
        it 'favoriteを削除しない' do
          favorite = create(:favorite, user: other, picture: picture)
          delete_params = { id: favorite.id, picture_id: picture.id }
          expect do
            delete :destroy, xhr: true, params: delete_params
          end.not_to change(Favorite, :count)
        end
        it '対象のpictureのfavorites_countが変化しない' do
          favorite = create(:favorite, user: other, picture: picture)
          delete_params = { id: favorite.id, picture_id: picture.id }
          delete :destroy, xhr: true, params: delete_params
          expect(picture.reload.favorites_count).to eq(1)
        end
      end
    end

    context 'ログインしていない場合' do
      it 'favoriteを削除しない' do
        favorite = create(:favorite, user: user, picture: picture)
        delete_params = { id: favorite.id, picture_id: picture.id }
        expect do
          delete :destroy, xhr: true, params: delete_params
        end.not_to change(Favorite, :count)
      end
      it '対象のpictureのfavorites_countが変化しない' do
        favorite = create(:favorite, user: user, picture: picture)
        delete_params = { id: favorite.id, picture_id: picture.id }
        delete :destroy, xhr: true, params: delete_params
        expect(picture.reload.favorites_count).to eq(1)
      end
      it 'ログインページにリダイレクトする' do
        favorite = create(:favorite, user: user, picture: picture)
        delete_params = { id: favorite.id, picture_id: picture.id }
        delete :destroy, xhr: true, params: delete_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end