class Micropost < ApplicationRecord
  belongs_to :user
  mount_uploader :picture, PictureUploader

  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.microposts.max_content}
  validate  :picture_size

  scope :newest, ->{order created_at: :desc}

  private

  def picture_size
    return unless picture.size > Settings.microposts.pic_size.megabytes
    flash[:danger] = t ".error"
  end
end
