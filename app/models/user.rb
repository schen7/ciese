class User < ActiveRecord::Base

  before_save { email.downcase! }

  VALID_USERNAME_REGEX = /\A[a-zA-Z0-9_\-.]+\z/
  validates :username, presence: true, length: { in: 3..30 }, uniqueness: true,
                       format: { with: VALID_USERNAME_REGEX }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@(?:[a-z\d\-]+\.)+[a-z]+\z/i
  validates :email, presence: true, length: { in: 8..50 },
                    uniqueness: { case_sensitive: false },
                    format: { with: VALID_EMAIL_REGEX }

  validates :admin, inclusion: { in: [true, false] }
  validates :staff, inclusion: { in: [true, false] }
  validates :active, inclusion: { in: [true, false] }
  validates :password, length: { minimum: 10 }
  validates :password_confirmation, length: { minimum: 10 }

  has_secure_password

  has_many :profiles, inverse_of: :user
end
