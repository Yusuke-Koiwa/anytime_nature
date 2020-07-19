require 'rails_helper'

describe CommentsController do
  let(:user)                { create(:user) }
  let(:other)               { create(:user) }
  let(:admin)               { create(:user, admin: true) }
  let(:picture)             { create(:picture, user: user) }
  let(:other_picture)       { create(:picture, user: other) }
  let(:comment)             { create(:comment, user: user, picture: picture) }
  let(:other_user_comment)  { create(:comment, user: other, picture: picture) }
  let(:params)              { { picture_id: other_picture.id, comment: { text: "hoge" } } }
  let(:invalid_params)      { { picture_id: other_picture.id, comment: { text: "" } } }
#--------------------------------------------------------------------------------
  describe "#create" do
    context "ログインしている場合" do
      before do
        login user
      end

      context "入力が正しい場合" do
        subject { post :create, xhr: true, params: params }
        it "commentを保存する" do
          expect { subject }.to change(Comment, :count).by(1)
        end
        it "notificationを保存する" do
          expect { subject }.to change(Notification, :count).by(1)
        end
        it "@commentsに正しい値が入っている" do
          subject
          expect(assigns(:comments)).to eq other_picture.comments
        end
      end

      context "入力が不正の場合" do
        subject { post :create, xhr: true, params: invalid_params }
        it "commentを保存しない" do
          expect { subject }.not_to change(Comment, :count)
        end
      end
    end

    context "ログインしていない場合" do
      it "ログインページに遷移すること" do
        post :create, params: params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
#--------------------------------------------------------------------------------
  describe '#destroy' do
    context 'ログインしている場合' do

      context '自身が管理ユーザーである場合' do
        before do
          login admin
        end

        it 'commentを削除する' do
          params = { picture_id: picture.id, id: comment.id }
          expect do
            delete :destroy, params: params, xhr: true
          end.to change(Comment, :count).by(-1)
        end
      end

      context '自身が管理ユーザーでない場合' do
        before do
          login user
        end

        context "自分が作成したcommentを削除する場合" do
          it 'commentを削除する' do
            params = { picture_id: picture.id, id: comment.id }
            expect do
              delete :destroy, params: params, xhr: true
            end.to change(Comment, :count).by(-1)
          end
        end

        context '他ユーザーのcommentを削除しようとした場合' do
          it 'commentを削除しない' do
            params = { picture_id: picture.id, xhr: true, id: other_user_comment.id }
            expect do
              delete :destroy, params: params
            end.to_not change(Comment, :count)
          end
          it 'トップページにリダイレクトする' do
            params = { picture_id: picture.id, xhr: true, id: other_user_comment.id }
            delete :destroy, params: params
            expect(response).to redirect_to(root_path)
          end
        end
      end
    end

    context 'ログインしていない場合' do
      it 'commentを削除しない' do
        params = { picture_id: picture.id, xhr: true, id: comment.id }
        expect do
          delete :destroy, params: params
        end.to_not change(Picture, :count)
      end
      it 'ログインページにリダイレクトする' do
        params = { picture_id: picture.id, xhr: true, id: comment.id }
        delete :destroy, params: params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
