class Board < ActiveRecord::Base
  class NotLoggedIn < StandardError; end
  class NotAuthorized < StandardError; end

  has_many :topics
  validates :name, presence: true, uniqueness: true, length: { maximum: 100 }

end
