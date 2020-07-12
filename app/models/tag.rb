class Tag < ApplicationRecord
  has_many :pictures, through: :picture_tags
  has_many :picture_tags, dependent: :destroy

  validates :name, presence: true, length: {maximum: 20}
end