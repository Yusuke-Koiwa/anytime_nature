require 'rails_helper'

describe RelationshipsController do
  let(:user)            { create(:user) }
  let(:other)           { create(:user) }
  let(:create_params)   { { user_id: other.id } }
  let(:invalid_params)  { { user_id: user.id } }
#--------------------------------------------------------------------------------
  describe "#create" do
    context "ログインしている場合" do
      before do
        login user
      end

      context 'ユーザーをフォローしていない場合'do
        subject { post :create, xhr: true, params: create_params }
        it "relationshipを保存する" do
          expect { subject }.to change(Relationship, :count).by(1)
        end
        it "notificationを保存する" do
          expect { subject }.to change(Notification, :count).by(1)
        end
      end

      context '既にユーザーをフォローしている場合' do
        subject { post :create, xhr: true, params: create_params }
        it "relationshipを保存しない" do
          create(:relationship, user: user, follow: other)
          expect { subject }.not_to change(Relationship, :count)
        end
        it "notificationを保存しない" do
          create(:notification, visitor_id: user.id, visited_id: other.id, action: "follow")
          expect { subject }.not_to change(Notification, :count)
        end
      end

      context '自分をフォローしようとした場合' do
        subject { post :create, xhr: true, params: invalid_params }
        it "relationshipを保存しない" do
          expect { subject }.not_to change(Relationship, :count)
        end
        it "notificationを保存しない" do
          expect { subject }.not_to change(Notification, :count)
        end
        it "トップページに遷移する" do
          subject
          expect(response).to redirect_to(root_path)
        end
      end
    end

    context "ログインしていない場合" do
      subject { post :create, xhr: true, params: create_params }
      it "relationshipを保存しない" do
        expect { subject }.not_to change(Relationship, :count)
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

      context 'ユーザーを既にフォローしている場合' do
        it 'relationshipsを削除する' do
          relationship = create(:relationship, user: user, follow: other)
          expect do
            delete :destroy, xhr: true, params: { id: relationship.id, user_id: other.id }
          end.to change(Relationship, :count).by(-1)
        end
      end

      context 'ユーザーをフォローしていない場合' do
        it 'relationshipsを削除しない' do
          third_person = create(:user)
          relationship = create(:relationship, user: third_person, follow: other)
          expect do
            delete :destroy, xhr: true, params: { id: relationship.id, user_id: other.id }
          end.not_to change(Relationship, :count)
        end
      end
    end

    context 'ログインしていない場合' do
      it 'relationshipを削除しない' do
        relationship = create(:relationship, user: user, follow: other)
        expect do
          delete :destroy, xhr: true, params: { id: relationship.id, user_id: other.id }
        end.not_to change(Relationship, :count)
      end
      it 'ログインページにリダイレクトする' do
        relationship = create(:relationship, user: user, follow: other)
        delete :destroy, xhr: true, params: { id: relationship.id, user_id: other.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end