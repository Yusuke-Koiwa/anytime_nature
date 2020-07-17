require 'rails_helper'
describe UsersController do
  let(:user)        { create(:user, name: "name") }
  let(:other)       { create(:user, name: "name") }
  let(:category)    { create(:category) }
  let(:picture)     { create(:picture, user: user, category: category) }
  let(:pictures)    { create_list(:picture, 3, user: user, category: category) }
#--------------------------------------------------------------------------------
  describe '#show' do
    it "@userに正しい値が入っている" do
      get :show, params: { id: user }
      expect(assigns(:user)).to eq user
    end
    it "@picturesに正しい値が入っている" do
      get :show, params: { id: user }
      expect(assigns(:pictures)).to match(pictures.sort { |a, b| b.id <=> a.id })
    end
    it "ソート機能を使用した場合に@picturesに正しい値が入っている" do
      get :show, params: { id: user, q: {sorts: 'id ASC'} }
      expect(assigns(:pictures)).to match(pictures.sort { |a, b| a.id <=> b.id })
    end
    it "show.html.hamlに遷移する" do
      get :show, params: {  id: user }
      expect(response).to render_template :show
    end
  end
#--------------------------------------------------------------------------------
  describe '#slideshow' do
    it "@userに正しい値が入っている" do
      get :slideshow, params: { id: user }
      expect(assigns(:user)).to eq user
    end
    it "@picturesに正しい値が入っている" do
      get :slideshow, params: { id: user }
      expect(assigns(:pictures)).to match(pictures.sort { |a, b| b.id <=> a.id })
    end
    it "ソート機能を使用した場合に@picturesに正しい値が入っている" do
      get :slideshow, params: { id: user, q: {sorts: 'id ASC'} }
      expect(assigns(:pictures)).to match(pictures.sort { |a, b| a.id <=> b.id })
    end
    it "slideshow.html.hamlに遷移する" do
      get :slideshow, params: {  id: user }
      expect(response).to render_template :slideshow
    end
  end
#--------------------------------------------------------------------------------
  describe '#edit' do
    context 'ログインしている場合' do
      before do
        login user
      end

      context '自身のユーザー情報を編集する場合' do
        it "@userに正しい値が入っている" do
          get :edit, params: { id: user }
          expect(assigns(:user)).to eq user
        end
        it "edit.html.hamlに遷移する" do
          get :edit, params: {  id: user }
          expect(response).to render_template :edit
        end
      end

      context '他ユーザーの情報を編集しようとした場合' do
        it "トップページにリダイレクトする" do
          get :edit, params: {  id: other }
          expect(response).to redirect_to(root_path)
        end
      end
    end

    context 'ログインしていない場合' do
      it "ログインページにリダイレクトする" do
        get :edit, params: { id: user }
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

      context "自身のユーザー情報を更新する場合" do
        it 'userを更新する' do
          params = { id: user.id, user: { name: "new_name" } }
          patch :update, params: params
          expect(user.reload.name).to eq("new_name")
        end
        it 'マイページにリダイレクトする' do
          params = { id: user.id, user: { name: "new_name" } }
          patch :update, params: params
          expect(response).to redirect_to(user_path(user))
        end
      end

      context '他ユーザーの情報を更新しようとした場合' do
        it 'userを更新しない' do
          params = { id: other.id, user: { name: "new_name" } }
          patch :update, params: params
          expect(user.reload.name).to eq("name")
        end
        it 'トップページにリダイレクトする' do
          params = { id: other.id, user: { name: "new_name" } }
          patch :update, params: params
          expect(response).to redirect_to(root_path)
        end
      end
    end

    context 'ログインしていない場合' do
      it 'userを更新しない' do
        params = { id: user.id, user: { name: "new_name" } }
        patch :update, params: params
        expect(user.reload.name).to eq("name")
      end
      it 'ログインページにリダイレクトする' do
        params = { id: user.id, user: { name: "new_name" } }
        patch :update, params: params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
#--------------------------------------------------------------------------------
  describe '#favorite' do
    context 'ログインしている場合' do
      before do
        login user
      end
      it "@picturesに正しい値が入っている" do
        pictures = create_list(:picture, 3) do |picture|
          create(:favorite, user: user, picture: picture)
        end
        get :favorite
        expect(assigns(:pictures)).to match(pictures.sort { |a, b| b.id <=> a.id })
      end
      it "ソート機能を使用した場合に@picturesに正しい値が入っている" do
        pictures = create_list(:picture, 3) do |picture|
          create(:favorite, user: user, picture: picture)
        end
        get :favorite, params: { q: {sorts: 'id ASC'} }
        expect(assigns(:pictures)).to match(pictures.sort { |a, b| a.id <=> b.id })
      end
      it "favorite.html.hamlに遷移する" do
        get :favorite
        expect(response).to render_template :favorite
      end
    end

    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトする' do
        get :favorite
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
#--------------------------------------------------------------------------------
  describe '#favorite_slideshow' do
    context 'ログインしている場合' do
      before do
        login user
      end
      it "@picturesに正しい値が入っている" do
        pictures = create_list(:picture, 3) do |p|
          create(:favorite, user: user, picture: p)
        end
        get :favorite_slideshow
        expect(assigns(:pictures)).to match(pictures.sort { |a, b| b.id <=> a.id })
      end
      it "ソート機能を使用した場合に@picturesに正しい値が入っている" do
        pictures = create_list(:picture, 3) do |p|
          create(:favorite, user: user, picture: p)
        end
        get :favorite_slideshow, params: { q: {sorts: 'id ASC'} }
        expect(assigns(:pictures)).to match(pictures.sort { |a, b| a.id <=> b.id })
      end
      it "favorite.html.hamlに遷移する" do
        get :favorite_slideshow
        expect(response).to render_template :favorite_slideshow
      end
    end

    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトする' do
        get :favorite_slideshow
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
#--------------------------------------------------------------------------------
  describe '#following' do
    it "@userに正しい値が入っている" do
      get :following, params: { id: user }
      expect(assigns(:user)).to eq user
    end
    it "@usersに正しい値が入っている" do
      create(:relationship, user: user, follow: other)
      get :following, params: { id: user }
      expect(assigns(:users)).to eq user.follow_users
    end
    it "following.html.hamlに遷移する" do
      get :following, params: {  id: user }
      expect(response).to render_template :following
    end
  end
#--------------------------------------------------------------------------------
  describe '#follower' do
    it "@userに正しい値が入っている" do
      get :follower, params: { id: user }
      expect(assigns(:user)).to eq user
    end
    it "@usersに正しい値が入っている" do  
      create(:relationship, user: other, follow: user)
      get :follower, params: { id: user }
      expect(assigns(:users)).to eq user.follower_users
    end
    it "follower.html.hamlに遷移する" do
      get :follower, params: {  id: user }
      expect(response).to render_template :follower
    end
  end
#--------------------------------------------------------------------------------
  describe '#post_show' do
    it "@userに正しい値が入っている" do
      get :post_show, params: { id: user, picture_id: picture.id }
      expect(assigns(:user)).to eq user
    end
    it "@pictureに正しい値が入っている" do
      get :post_show, params: { id: user, picture_id: picture.id }
      expect(assigns(:picture)).to eq picture
    end
    it "@picturesに正しい値が入っている" do
      get :post_show, params: { id: user, picture_id: picture.id }
      expect(assigns(:pictures)).to eq user.pictures
    end
    it "@categoryに正しい値が入っている" do
      get :post_show, params: { id: user, picture_id: picture.id }
      expect(assigns(:category)).to eq picture.category
    end
    it "@tag_listに正しい値が入っている" do
      tag1 = create(:tag, name: "a")
      tag2 = create(:tag, name: "b")
      create(:picture_tag, picture_id: picture.id, tag_id: tag1.id)
      create(:picture_tag, picture_id: picture.id, tag_id: tag2.id)
      get :post_show, params: { id: user, picture_id: picture.id }
      expect(assigns(:tag_list)).to eq picture.tags.pluck(:name).join(",")
    end
    it "all_tagsに正しい値が入っている" do
      tag1 = create(:tag, name: "a")
      tag2 = create(:tag, name: "b")
      get :post_show, params: { id: user, picture_id: picture.id }
      expect(assigns(:all_tags)).to eq Tag.pluck(:name)
    end
    it "@commentsに正しい値が入っている" do
      comments = create_list(:comment, 3, picture: picture)
      get :post_show, params: { id: user, picture_id: picture.id }
      expect(assigns(:comments)).to match(comments.sort { |a, b| b.id <=> a.id })
    end
    it "post_show.html.hamlに遷移する" do
      get :post_show, params: { id: user, picture_id: picture.id }
      expect(response).to render_template :post_show
    end
  end
#--------------------------------------------------------------------------------
  describe '#favorite_show' do
    before do
      login user
    end
    it "@pictureに正しい値が入っている" do
      create(:favorite, user: user, picture: picture)
      get :favorite_show, params: { picture_id: picture.id }
      expect(assigns(:picture)).to eq picture
    end
    it "@picturesに正しい値が入っている" do
      pictures = create_list(:picture, 3) do |p|
        create(:favorite, user: user, picture: p)
      end
      get :favorite_show, params: { picture_id: pictures[0].id }
      expect(assigns(:pictures)).to eq pictures
    end
    it "@categoryに正しい値が入っている" do
      create(:favorite, user: user, picture: picture)
      get :favorite_show, params: { picture_id: picture.id }
      expect(assigns(:category)).to eq picture.category
    end
    it "@tag_listに正しい値が入っている" do
      create(:favorite, user: user, picture: picture)
      tag1 = create(:tag, name: "a")
      tag2 = create(:tag, name: "b")
      create(:picture_tag, picture_id: picture.id, tag_id: tag1.id)
      create(:picture_tag, picture_id: picture.id, tag_id: tag2.id)
      get :favorite_show, params: { picture_id: picture.id }
      expect(assigns(:tag_list)).to eq picture.tags.pluck(:name).join(",")
    end
    it "all_tagsに正しい値が入っている" do
      create(:favorite, user: user, picture: picture)
      tag1 = create(:tag, name: "a")
      tag2 = create(:tag, name: "b")
      get :favorite_show, params: { picture_id: picture.id }
      expect(assigns(:all_tags)).to eq Tag.pluck(:name)
    end
    it "@commentsに正しい値が入っている" do
      create(:favorite, user: user, picture: picture)
      comments = create_list(:comment, 3, picture: picture)
      get :favorite_show, params: { picture_id: picture.id }
      expect(assigns(:comments)).to match(comments.sort { |a, b| b.id <=> a.id })
    end
    it "post_show.html.hamlに遷移する" do
      create(:favorite, user: user, picture: picture)
      get :favorite_show, params: { picture_id: picture.id }
      expect(response).to render_template :favorite_show
    end
  end
end