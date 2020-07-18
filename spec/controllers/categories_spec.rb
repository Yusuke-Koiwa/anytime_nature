require 'rails_helper'
describe CategoriesController do
  let(:user)              { create(:user) }
  let(:parent_categories) { create_list(:category, 3, ancestry: nil) }
  let(:parent_category)   { create(:category, id: 1, ancestry: nil) }
  let(:category)          { create(:category, ancestry: "1") }
  let(:children)          { create_list(:category, 3, ancestry: "1") }
  let(:picture)           { create(:picture, category: category) }
  let(:comments)          { create_list(:comment, 3, picture: picture) }
  let(:tag1)              { create(:tag, name: "a") }
  let(:tag2)              { create(:tag, name: "b") }
#--------------------------------------------------------------------------------
  describe '#index' do
    it '@parentsに正しい値が入っている' do
      get :index
      expect(assigns(:parents)).to eq parent_categories
    end
    it '@imagesに正しい値が入っている' do
      get :index
      expect(assigns(:images)).to eq(["forest.jpg", "flower.jpg", "mountain.jpg", "ground.jpg", "sea.jpg", "river.jpg", "sky.jpg", "snow.jpg"])
    end
    it 'index.html.hamlに遷移する' do
      get :index
      expect(response).to render_template :index
    end
  end
#--------------------------------------------------------------------------------
  describe '#show' do
    it '@categoryに正しい値が入っている' do
      get :show, params: { id: category.id }
      expect(assigns(:category)).to eq category
    end
    it '@picturesに正しい値が入っている' do
      pictures = create_list(:picture, 3, category: category)
      get :show, params: { id: category.id }
      expect(assigns(:pictures)).to match(pictures.sort { |a, b| b.id <=> a.id })
    end
    it 'ソート機能を使用した場合に@picturesに正しい値が入っている' do
      pictures = create_list(:picture, 3, category: category)
      get :show, params: { id: category.id, q: { sorts: "id ASC" } }
      expect(assigns(:pictures)).to match(pictures.sort { |a, b| a.id <=> b.id })
    end
    it "show.html.hamlに遷移する" do
      get :show, params: { id: category.id }
      expect(response).to render_template :show
    end
  end
#--------------------------------------------------------------------------------
  describe '#slideshow' do
    it '@categoryに正しい値が入っている' do
      get :slideshow, params: { id: category.id }
      expect(assigns(:category)).to eq category
    end
    it '@picturesに正しい値が入っている' do
      pictures = create_list(:picture, 3, category: category)
      get :slideshow, params: { id: category.id }
      expect(assigns(:pictures)).to match(pictures.sort { |a, b| b.id <=> a.id })
    end
    it 'ソート機能を使用した場合に@picturesに正しい値が入っている' do
      pictures = create_list(:picture, 3, category: category)
      get :slideshow, params: { id: category.id, q: { sorts: "id ASC" } }
      expect(assigns(:pictures)).to match(pictures.sort { |a, b| a.id <=> b.id })
    end
    it "show.html.hamlに遷移する" do
      get :slideshow, params: { id: category.id }
      expect(response).to render_template :slideshow
    end
  end
#--------------------------------------------------------------------------------
  describe '#picture' do
    it '@categoryに正しい値が入っている' do
      get :picture, params: { id: category.id, picture_id: picture.id }
      expect(assigns(:category)).to eq category
    end
    it '@pictureに正しい値が入っている' do
      get :picture, params: { id: category.id, picture_id: picture.id }
      expect(assigns(:picture)).to eq picture
    end
    it '@commentsに正しい値が入っている' do
      get :picture, params: { id: category.id, picture_id: picture.id }
      expect(assigns(:comments)).to match(comments.sort { |a, b| b.created_at <=> a.created_at })
    end
    it '@tag_listに正しい値が入っている' do
      create(:picture_tag, picture_id: picture.id, tag_id: tag1.id)
      create(:picture_tag, picture_id: picture.id, tag_id: tag2.id)
      get :picture, params: { id: category.id, picture_id: picture.id }
      expect(assigns(:tag_list)).to eq [tag1, tag2].pluck(:name).join(",")
    end
    it "picture.html.hamlに遷移する" do
      get :picture, params: { id: category.id, picture_id: picture.id }
      expect(response).to render_template :picture
    end
  end
#--------------------------------------------------------------------------------
  describe '#parent_picture' do
    it '@categoryに正しい値が入っている' do
      get :parent_picture, params: { id: category.id, picture_id: picture.id }
      expect(assigns(:category)).to eq category
    end
    it '@pictureに正しい値が入っている' do
      get :parent_picture, params: { id: category.id, picture_id: picture.id }
      expect(assigns(:picture)).to eq picture
    end
    it '@commentsに正しい値が入っている' do
      get :parent_picture, params: { id: category.id, picture_id: picture.id }
      expect(assigns(:comments)).to match(comments.sort { |a, b| b.created_at <=> a.created_at })
    end
    it '@tag_listに正しい値が入っている' do
      create(:picture_tag, picture_id: picture.id, tag_id: tag1.id)
      create(:picture_tag, picture_id: picture.id, tag_id: tag2.id)
      get :parent_picture, params: { id: category.id, picture_id: picture.id }
      expect(assigns(:tag_list)).to eq [tag1, tag2].pluck(:name).join(",")
    end
    it "parent_picture.html.hamlに遷移する" do
      get :parent_picture, params: { id: category.id, picture_id: picture.id }
      expect(response).to render_template :parent_picture
    end
  end
#--------------------------------------------------------------------------------
  describe '#children' do
    it '@childrenに正しい値が入っている' do
      get :children, params: { parentCategory: parent_category.id}, xhr: true
      expect(assigns(:children)).to eq children
    end
  end
end