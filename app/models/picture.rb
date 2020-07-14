class Picture < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :favorites, dependent: :destroy
  has_many :picture_tags, dependent: :destroy
  has_many :tags, through: :picture_tags
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy

  mount_uploader :image, ImageUploader

  validates :image, presence: true

  def save_tags(tags)
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    old_tags = current_tags - tags
    new_tags = tags - current_tags

    old_tags.each do |old_name|
      self.tags.delete Tag.find_by(name: old_name)
    end

    new_tags.each do |new_name|
      picture_tag = Tag.find_or_create_by(name: new_name)
      self.tags << picture_tag
    end
  end

  def create_notification_favorite(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and picture_id = ? and action = ? ", current_user.id, user_id, id, 'favorite'])
    return unless temp.blank?

    notification = current_user.active_notifications.new(
      picture_id: id,
      visited_id: user_id,
      action: 'favorite'
    )
    notification.checked = true if notification.visitor_id == notification.visited_id
    notification.save if notification.valid?
  end

  def create_notification_comment(current_user, comment_id)
    temp_ids = Comment.select(:user_id).where(picture_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment(current_user, comment_id, temp_id['user_id'])
    end
    save_notification_comment(current_user, comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_comment(current_user, comment_id, visited_id)
    notification = current_user.active_notifications.new(
      picture_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    notification.checked = true if notification.visitor_id == notification.visited_id
    notification.save if notification.valid?
  end

end