class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :picture, counter_cache: :comments_count
  has_many :notifications, dependent: :destroy

  validates :text, presence: true
end