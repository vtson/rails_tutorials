class User < ApplicationRecord
  attr_reader :remember_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  enum sex: [:unknown, :male, :female, :n_a]

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
    length: {minimum: Settings.model_user.password.minimum},
    allow_nil: true

  before_save :email_downcase

  has_secure_password

  class << self
    def digest string
      cost =
        if ActiveModel::SecurePassword.min_cost
          BCrypt::Engine::MIN_COST
        else
          BCrypt::Engine.cost
        end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    @remember_token = User.new_token
    update_attributes! remember_digest: User.digest(remember_token)
  end

  def authenticated? remember_token
    return false unless remember_digest
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_attributes! remember_digest: nil
  end

  private

  def email_downcase
    email.downcase!
  end
end
