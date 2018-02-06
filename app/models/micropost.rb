class Micropost < ApplicationRecord
  belongs_to :user
  mount_uploader :picture, PictureUploader

  validates :user, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.microposts.max_content}
  validate :picture_size

  scope :post_followings, ->(following){where user_id: following}

  private

  def picture_size
    return unless picture.size > Settings.microposts.pic_size.megabytes
    flash[:danger] = t ".error"
  end
end
