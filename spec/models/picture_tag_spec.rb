require 'rails_helper'

describe PictureTag do
  describe '#create' do
    it "picture_id, tag_idの全てが存在すれば登録できる" do
      picture = create(:picture)
      tag = create(:tag)
      picture_tag = build(:picture_tag, picture_id: picture.id, tag_id: tag.id)
      expect(picture_tag).to be_valid
    end

    it "picture_idが存在しない場合は登録できない" do
      tag = create(:tag)
      picture_tag = build(:picture_tag, picture_id: nil, tag_id: tag.id)
      picture_tag.valid?
      expect(picture_tag.errors[:picture_id]).to include("を入力してください")
    end

    it "tag_idが存在しない場合は登録できない" do
      picture = create(:picture)
      picture_tag = build(:picture_tag, picture_id: picture.id, tag_id: nil)
      picture_tag.valid?
      expect(picture_tag.errors[:tag_id]).to include("を入力してください")
    end
  end
end