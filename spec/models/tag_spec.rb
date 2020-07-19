require 'rails_helper'

describe Tag do
  describe '#create' do
    it "nameが存在すれば登録できる" do
      tag = build(:tag)
      expect(tag).to be_valid
    end

    it "nameが存在しない場合は登録できない" do
      tag = build(:tag, name: nil)
      tag.valid?
      expect(tag.errors[:name]).to include("を入力してください")
    end

    it "nameが20文字以上の場合は登録できない" do
      tag = build(:tag, name: "123456789012345678901")
      tag.valid?
      expect(tag.errors[:name]).to include("は20文字以内で入力してください")
    end

  end
end