class Picture < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :favorites, dependent: :destroy

  mount_uploader :image, ImageUploader

  validates :title, :image, presence: true
end