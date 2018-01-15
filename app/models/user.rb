class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :firstname, presence: true,
    length: {minimum: Settings.model_user.firstname.minimum}
  validates :lastname, presence: true,
    length: {minimum: Settings.model_user.lastname.minimum}
  validates :displayname, presence: true,
    length: {maximum: Settings.model_user.displayname.maximum}
  validates :age, presence: true,
    numericality: {greater_than: Settings.model_user.age.minimum}
  validates :email, presence: true,
    length: {maximum: Settings.model_user.email.maximum},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.model_user.password.minimum}

  before_save :email_downcase

  has_secure_password

  def email_downcase
    email.downcase!
  end
end
