class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :picture, counter_cache: :favorites_count
end
