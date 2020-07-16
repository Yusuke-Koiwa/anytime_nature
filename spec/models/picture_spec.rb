require 'rails_helper'

describe Picture do
  describe '#create' do
    it "image, category_id, user_idの全てが存在すれば登録できる" do
      picture = build(:picture)
      expect(picture).to be_valid
    end

    it "imageが存在しない場合は登録できない" do
      picture = build(:picture, image: nil)
      picture.valid?
      expect(picture.errors[:image]).to include("を入力してください")
    end

    it "user_idが存在しない場合は登録できない" do
      picture = build(:picture, user_id: nil)
      picture.valid?
      expect(picture.errors[:user]).to include("を入力してください")
    end

    it "category_idが存在しない場合は登録できない" do
      picture = build(:picture, category_id: nil)
      picture.valid?
      expect(picture.errors[:category]).to include("を入力してください")
    end
  end
end