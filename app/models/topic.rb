class Topic < ActiveRecord::Base
  class NotLoggedIn < StandardError; end
  class NotAuthorized < StandardError; end

  belongs_to :board
  has_many :posts
  validates :board_id, presence: true
  validates :name, presence: true, length: { maximum: 100 }
end
