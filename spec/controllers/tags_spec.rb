require 'rails_helper'
describe TagsController do
  let(:user)              { create(:user) }
  let(:picture)           { create(:picture) }
  let(:comments)          { create_list(:comment, 3, picture: picture) }
  let(:tag1)              { create(:tag, name: "a") }
  let(:tag2)              { create(:tag, name: "b") }
  let(:tag3)              { create(:tag, name: "c") }
#--------------------------------------------------------------------------------
  describe '#show' do
    it '@tagに正しい値が入っている' do
      get :show, params: { id: tag1.id }
      expect(assigns(:tag)).to eq tag1
    end
    it '@picturesに正しい値が入っている' do
      pictures = create_list(:picture, 3) do |p|
        create(:picture_tag, picture_id: p.id, tag_id: tag1.id)
      end
      get :show, params: { id: tag1.id }
      expect(assigns(:pictures)).to match(pictures.sort { |a, b| b.id <=> a.id })
    end
    it 'ソート機能を使用した場合に@picturesに正しい値が入っている' do
      pictures = create_list(:picture, 3) do |p|
        create(:picture_tag, picture_id: p.id, tag_id: tag1.id)
      end
      get :show, params: { id: tag1.id , q: { sorts: "id ASC" } }
      expect(assigns(:pictures)).to match(pictures.sort { |a, b| a.id <=> b.id })
    end
    it "show.html.hamlに遷移する" do
      get :show, params: { id: tag1.id }
      expect(response).to render_template :show
    end
  end
#--------------------------------------------------------------------------------
  describe '#slideshow' do
    it '@tagに正しい値が入っている' do
      get :slideshow, params: { id: tag1.id }
      expect(assigns(:tag)).to eq tag1
    end
    it '@picturesに正しい値が入っている' do
      pictures = create_list(:picture, 3) do |p|
        create(:picture_tag, picture_id: p.id, tag_id: tag1.id)
      end
      get :slideshow, params: { id: tag1.id }
      expect(assigns(:pictures)).to match(pictures.sort { |a, b| b.id <=> a.id })
    end
    it 'ソート機能を使用した場合に@picturesに正しい値が入っている' do
      pictures = create_list(:picture, 3) do |p|
        create(:picture_tag, picture_id: p.id, tag_id: tag1.id)
      end
      get :slideshow, params: { id: tag1.id , q: { sorts: "id ASC" } }
      expect(assigns(:pictures)).to match(pictures.sort { |a, b| a.id <=> b.id })
    end
    it "show.html.hamlに遷移する" do
      get :slideshow, params: { id: tag1.id }
      expect(response).to render_template :slideshow
    end
  end
#--------------------------------------------------------------------------------
  describe '#picture' do
    it '@tagに正しい値が入っている' do
      create(:picture_tag, picture_id: picture.id, tag_id: tag1.id)
      get :picture, params: { id: tag1.id, picture_id: picture.id }
      expect(assigns(:tag)).to eq tag1
    end
    it '@pictureに正しい値が入っている' do
      create(:picture_tag, picture_id: picture.id, tag_id: tag1.id)
      get :picture, params: { id: tag1.id, picture_id: picture.id }
      expect(assigns(:picture)).to eq picture
    end
    it '@commentsに正しい値が入っている' do
      create(:picture_tag, picture_id: picture.id, tag_id: tag1.id)
      get :picture, params: { id: tag1.id, picture_id: picture.id }
      expect(assigns(:comments)).to match(comments.sort { |a, b| b.created_at <=> a.created_at })
    end
    it '@tag_listに正しい値が入っている' do
      create(:picture_tag, picture_id: picture.id, tag_id: tag1.id)
      create(:picture_tag, picture_id: picture.id, tag_id: tag2.id)
      get :picture, params: { id: tag1.id, picture_id: picture.id }
      expect(assigns(:tag_list)).to eq [tag1, tag2].pluck(:name).join(",")
    end
    it "picture.html.hamlに遷移する" do
      create(:picture_tag, picture_id: picture.id, tag_id: tag1.id)
      get :picture, params: { id: tag1.id, picture_id: picture.id }
      expect(response).to render_template :picture
    end
  end
end