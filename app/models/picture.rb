class Picture < ApplicationRecord
  belongs_to :user
  belongs_to :category

  mount_uploader :image, ImageUploader

  validates :title, :image, presence: true
end