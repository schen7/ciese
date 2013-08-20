class User < ActiveRecord::Base

  has_many :profiles, inverse_of: :user

  before_save { email.downcase! }

  VALID_USERNAME_REGEX = /\A[a-zA-Z0-9_\-.]+\z/
  validates :username, presence: true, length: { in: 3..30 }, uniqueness: true,
                       format: { with: VALID_USERNAME_REGEX }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@(?:[a-z\d\-]+\.)+[a-z]+\z/i
  validates :email, presence: true, length: { in: 8..50 },
                    uniqueness: { case_sensitive: false },
                    format: { with: VALID_EMAIL_REGEX }

  has_secure_password
  validates :password, length: { minimum: 10 }, on: :create
  validates :password_confirmation, presence: true, on: :create
  validates :password, length: { minimum: 10 }, on: :update, if: :password_changed?
  validates :password_confirmation, presence: true, on: :update, if: :password_changed?    

  validates :admin, inclusion: { in: [true, false] }
  validates :staff, inclusion: { in: [true, false] }
  validates :active, inclusion: { in: [true, false] }

  private

  def password_changed?
    !password.blank? || password_digest.blank?
  end
end
