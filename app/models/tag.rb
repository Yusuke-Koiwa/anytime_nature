class Tag < ApplicationRecord
  has_many :picture_tags, dependent: :destroy
  has_many :pictures, through: :picture_tags

  validates :name, presence: true, length: {maximum: 20}
end