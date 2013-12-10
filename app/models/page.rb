class Page < ActiveRecord::Base

  belongs_to :user

  validates :url, presence: true, format: { 
    with: /\A(?:\/|(?:(?:\/[~%\+\-\.\w]+)+\/?))\z/, message: "Not a valid url."
  }
  validates :user, presence: true

end
