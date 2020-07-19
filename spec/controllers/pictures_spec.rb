require 'rails_helper'
describe PicturesController do
  let(:user)          { create(:user) }
  let(:other)         { create(:user) }
  let(:admin)         { create(:user, admin: true) }
  let(:category)      { create(:category) }
  let(:picture)       { create(:picture, user: user, category: category) }
  let(:other_picture) { create(:picture, user: other, category: category) }
  let(:pictures)      { create_list(:picture, 3, category: category) }
  let(:params)        { { picture: { image: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/test.jpg')), category_id: category.id }, tag_list: "a,b,c" } }
  let(:blank_params)  { { picture: { image: nil, category_id: nil } } }
#--------------------------------------------------------------------------------
  describe '#index' do
    it '@picturesに正しい値が入っている' do
      get :index
      expect(assigns(:pictures)).to match(pictures.sort { |a, b| b.id <=> a.id })
    end
    it "ソート機能を使用した場合に@picturesに正しい値が入っている" do
      get :index, params: { q: {sorts: 'id ASC'} }
      expect(assigns(:pictures)).to match(pictures.sort { |a, b| a.id <=> b.id })
    end
    it 'index.html.hamlに遷移する' do
      get :index
      expect(response).to render_template :index
    end
  end
#--------------------------------------------------------------------------------
  describe '#slideshow' do
    it '@picturesに正しい値が入っている' do
      get :slideshow
      expect(assigns(:pictures)).to match(pictures.sort { |a, b| b.id <=> a.id })
    end
    it "ソート機能を使用した場合に@picturesに正しい値が入っている" do
      get :slideshow, params: { q: {sorts: 'id ASC'} }
      expect(assigns(:pictures)).to match(pictures.sort { |a, b| a.id <=> b.id })
    end
    it 'index.html.hamlに遷移する' do
      get :slideshow
      expect(response).to render_template :slideshow
    end
  end
#--------------------------------------------------------------------------------
  describe '#show' do
    it "@pictureに正しい値が入っている" do
      get :show, params: { id: picture.id }
      expect(assigns(:picture)).to eq picture
    end
    it "@categoryに正しい値が入っている" do
      get :show, params: { id: picture.id }
      expect(assigns(:category)).to eq category
    end
    it "@tag_listに正しい値が入っている" do
      tag1 = create(:tag, name: "a")
      tag2 = create(:tag, name: "b")
      create(:picture_tag, picture_id: picture.id, tag_id: tag1.id)
      create(:picture_tag, picture_id: picture.id, tag_id: tag2.id)
      get :show, params: { id: picture.id }
      expect(assigns(:tag_list)).to eq picture.tags.pluck(:name).join(",")
    end
    it "@commentsに正しい値が入っている" do
      comments = create_list(:comment, 3, picture: picture)
      get :show, params: { id: picture.id }
      expect(assigns(:comments)).to match(comments.sort { |a, b| b.id <=> a.id })
    end
    it "show.html.hamlに遷移する" do
      get :show, params: { id: picture.id }
      expect(response).to render_template :show
    end
  end
#--------------------------------------------------------------------------------
describe '#new' do
  context 'ログインしている場合' do
    before do
      login user
    end
    it "new.html.hamlに遷移する" do
      get :new
      expect(response).to render_template :new
    end
  end

  context 'ログインしていない場合' do
    it 'ログインページにリダイレクトする' do
      get :new
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
#--------------------------------------------------------------------------------
  describe '#create' do
    context 'ログインしている場合' do
      before do
        login user
      end

      context '入力が正しい場合' do
        subject { post :create, params: params }
        it 'pictureを保存する' do
          expect { subject }.to change(Picture, :count).by(1)
        end
        it 'tagが入力されている場合、tagを保存する' do
          expect { subject }.to change(Tag, :count).by(3)
        end
        it 'tagが入力されていない場合でもpictureは保存する' do
          no_tag_params = { picture: { image: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/test.jpg')), category_id: category.id } }
          expect {
            post :create, params: no_tag_params
          }.to change(Picture, :count).by(1)
        end
        it 'トップページにリダイレクトする' do
          subject
          expect(response).to redirect_to(root_path)
        end
      end

      context '入力が不正の場合' do
        subject { post :create, params: blank_params }
        it 'pictureを保存しない' do
          expect { subject }.not_to change(Picture, :count)
        end
        it '新規投稿ページにリダイレクトする' do
          subject
          expect(response).to redirect_to(new_picture_path)
        end
      end
    end

    context 'ログインしていない場合' do
      subject { post :create, params: params }
      it 'pictureを保存しない' do
        expect { subject }.not_to change(Picture, :count)
      end
      it 'ログインページにリダイレクトする' do
        subject
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
#--------------------------------------------------------------------------------
  describe '#update' do
    context 'ログインしている場合' do
      before do
        login user
      end

      context '自分の投稿を更新する場合' do
        it 'tagを更新する' do
          update_params = { id: picture.id, tag_list: "a,b,c" }
          expect do
            patch :update, params: update_params
          end.to change(Tag, :count).by(3)
        end
        it '直前のページにリダイレクトする' do
          update_params = { id: picture.id, tag_list: "a,b,c" }
          patch :update, params: update_params
          expect(response).to redirect_to(root_path)
        end
      end

      context '他人の投稿を更新しようとした場合' do
        it 'tagを更新しない' do
          update_params = { id: other_picture.id, tag_list: "a,b,c,d,e" }
          expect do
            patch :update, params: update_params
          end.not_to change(Tag, :count)
        end
        it 'トップページにリダイレクトする' do
          update_params = { id: other_picture.id, tag_list: "a,b,c,d,e" }
          patch :update, params: update_params
          expect(response).to redirect_to(root_path)
        end
      end
    end

    context 'ログインしていない場合' do
      it 'tagを更新しない' do
        update_params = { id: picture.id, tag_list: "a,b,c,d,e" }
        expect do
          patch :update, params: update_params
        end.not_to change(Tag, :count)
      end
      it 'ログインページにリダイレクトする' do
        update_params = { id: picture.id, tag_list: "a,b,c,d,e" }
        patch :update, params: update_params
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

        it 'pictureを削除する' do
          params = { id: picture.id }
          expect do
            delete :destroy, params: params
          end.to change(Picture, :count).by(-1)
        end
        it 'トップページにリダイレクトする' do
          params = { id: picture.id }
          delete :destroy, params: params
          expect(response).to redirect_to(root_path)
        end
      end

      context '自身が管理ユーザーでない場合' do
        before do
          login user
        end

        context "自分が作成したpictureを削除する場合" do
          it 'pictureを削除する' do
            params = { id: picture.id }
            expect do
              delete :destroy, params: params
            end.to change(Picture, :count).by(-1)
          end
          it 'トップページにリダイレクトする' do
            params = { id: picture.id }
            delete :destroy, params: params
            expect(response).to redirect_to(root_path)
          end
        end

        context '他ユーザーのpictureを削除しようとした場合' do
          it 'pictureを削除しない' do
            params = { id: other_picture.id }
            expect do
              delete :destroy, params: params
            end.to_not change(Picture, :count)
          end
          it 'トップページにリダイレクトする' do
            params = { id: other_picture.id }
            delete :destroy, params: params
            expect(response).to redirect_to(root_path)
          end
        end
      end
    end

    context 'ログインしていない場合' do
      it 'pictureを削除しない' do
        params = { id: picture.id }
        expect do
          delete :destroy, params: params
        end.to_not change(Picture, :count)
      end
      it 'ログインページにリダイレクトする' do
        params = { id: picture.id }
        delete :destroy, params: params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end