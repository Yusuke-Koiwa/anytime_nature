class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :pictures, dependent: :destroy
  has_many :favorites, dependent: :destroy

  mount_uploader :image, IconsUploader
  
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end