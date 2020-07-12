class Picture < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :favorites, dependent: :destroy
  has_many :tags, through: :picture_tags
  has_many :picture_tags, dependent: :destroy

  mount_uploader :image, ImageUploader

  validates :title, :image, presence: true
end