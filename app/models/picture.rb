class Picture < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :favorites, dependent: :destroy
  has_many :picture_tags, dependent: :destroy
  has_many :tags, through: :picture_tags
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy

  mount_uploader :image, ImageUploader

  validates :image, presence: true

  def save_tags(tags)
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    old_tags = current_tags - tags
    new_tags = tags - current_tags

    old_tags.each do |old_name|
      self.tags.delete Tag.find_by(name: old_name)
    end

    new_tags.each do |new_name|
      picture_tag = Tag.find_or_create_by(name: new_name)
      self.tags << picture_tag
    end
  end
end