require 'rails_helper'

describe Favorite do
  describe '#create' do
    it "user_id, picture_idの全てが存在すれば登録できる" do
      favorite = build(:favorite)
      expect(favorite).to be_valid
    end

    it "user_idが存在しない場合は登録できない" do
      favorite = build(:favorite, user_id: nil)
      favorite.valid?
      expect(favorite.errors[:user]).to include("を入力してください")
    end

    it "picture_idが存在しない場合は登録できない" do
      favorite = build(:favorite, picture_id: nil)
      favorite.valid?
      expect(favorite.errors[:picture]).to include("を入力してください")
    end

    it "user_id, picture_idの組み合わせは一意でなければならない" do
      user = create(:user)
      picture = create(:picture, user: user)
      create(:favorite, user: user, picture: picture)
      favorite = build(:favorite, user: user, picture: picture)
      favorite.valid?
      expect(favorite.errors[:picture_id]).to include("はすでに存在します")
    end
  end
end
