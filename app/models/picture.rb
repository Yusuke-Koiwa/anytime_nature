class Picture < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :favorites, dependent: :destroy

  mount_uploader :image, ImageUploader

  validates :title, :image, presence: true

  def previous
    Picture.where("id > ?", self.id).order("id ASC").first
  end

  def next
    Picture.where("id < ?", self.id).order("id DESC").first
  end
end