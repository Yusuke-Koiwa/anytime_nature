class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :picture, counter_cache: :comments_count

  validates :text, presence: true
end