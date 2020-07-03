class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :pictures
  
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
