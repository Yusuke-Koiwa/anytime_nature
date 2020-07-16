require 'rails_helper'

describe Comment do
  describe '#create' do
    it "text, user_id, picture_idの全てが存在すれば登録できる" do
      comment = build(:comment)
      expect(comment).to be_valid
    end

    it "textが存在しない場合は登録できない" do
      comment = build(:comment, text: nil)
      comment.valid?
      expect(comment.errors[:text]).to include("を入力してください")
    end

    it "user_idが存在しない場合は登録できない" do
      comment = build(:comment, user_id: nil)
      comment.valid?
      expect(comment.errors[:user]).to include("を入力してください")
    end

    it "picture_idが存在しない場合は登録できない" do
      comment = build(:comment, picture_id: nil)
      comment.valid?
      expect(comment.errors[:picture]).to include("を入力してください")
    end
  end
end