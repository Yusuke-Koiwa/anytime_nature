class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :pictures, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_pictures, through: :favorites, source: :picture

  mount_uploader :image, IconsUploader
  
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  def already_favorite?(picture)
    favorite_pictures.include?(picture)
  end

  def create_favorite(picture)
    favorites.find_or_create_by(picture_id: picture.id)
  end

  def delete_favorite(picture)
    favorite = favorites.find_by(picture_id: picture.id)
    favorite&.destroy
  end

  def favorites_sum
    sum = 0
    self.pictures.where("favorites_count > ?", 0).each do |picture|
      sum += picture.favorites_count
    end
    return sum
  end
end