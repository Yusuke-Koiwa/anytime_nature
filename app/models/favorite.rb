class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :picture, counter_cache: :favorites_count
  validates_uniqueness_of :picture_id, scope: :user_id
end