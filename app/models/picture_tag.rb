class PictureTag < ApplicationRecord
  belongs_to :picture
  belongs_to :tag
  
  validates :picture_id, :tag_id, presence: true
end