class Page < ActiveRecord::Base

  belongs_to :user

  validates :url, presence: true
  validates :user, presence: true

end
