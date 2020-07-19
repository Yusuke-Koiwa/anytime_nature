class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :pictures, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_pictures, through: :favorites, source: :picture
  has_many :relationships, dependent: :destroy
  has_many :follow_users, through: :relationships, source: :follow
  has_many :reverse_relationships, class_name: 'Relationship', foreign_key: 'follow_id', dependent: :destroy
  has_many :follower_users, through: :reverse_relationships, source: :user
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy

  mount_uploader :image, IconsUploader
  
  validates :name, presence: true, length: { maximum: 20 }
  validates :email, presence: true, uniqueness: true
  validates :password, :password_confirmation, presence: true, on: :create

  def already_favorite?(picture)
    favorite_pictures.include?(picture)
  end

  def create_favorite(picture)
    favorites.find_or_create_by(picture_id: picture.id)
  end

  def delete_favorite(picture)
    favorite = favorites.find_by(picture_id: picture.id)
    favorite&.destroy
  end

  def favorites_sum
    sum = 0
    self.pictures.where("favorites_count > ?", 0).each do |picture|
      sum += picture.favorites_count
    end
    return sum
  end

  def already_followed?(other_user)
    follow_users.include?(other_user)
  end

  def follow(other_user)
    relationships.find_or_create_by(follow_id: other_user.id) unless self == other_user
  end

  def unfollow(other_user)
    relationship = relationships.find_by(follow_id: other_user.id)
    relationship&.destroy
  end

  def create_notification_follow(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ? ", current_user.id, id, 'follow'])
    return unless temp.blank?

    notification = current_user.active_notifications.new(
      visited_id: id,
      action: 'follow'
    )
    notification.save if notification.valid?
  end

end