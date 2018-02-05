class Micropost < ApplicationRecord
  belongs_to :user
  mount_uploader :picture, PictureUploader

  validates :user, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.microposts.max_content}
  validate :picture_size

  scope :following_feed, (lambda do |user_id, following_ids|
    where(user_id: [user_id, *following_ids])
  end)

  private

  def picture_size
    return unless picture.size > Settings.microposts.pic_size.megabytes
    flash[:danger] = t ".error"
  end
end
