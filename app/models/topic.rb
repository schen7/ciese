class Topic < ActiveRecord::Base
  belongs_to :board
  has_many :posts
  validates :board_id, presence: true
  validates :name, presence: true, length: { maximum: 100 }
end
