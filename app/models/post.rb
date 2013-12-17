class Post < ActiveRecord::Base
  #class NotLoggedIn < StandardError; end
  #class NotAuthorized < StandardError; end

  belongs_to :topic
  has_many :comments
  validates :topic_id, presence: true
  validates :author, presence: true
  validates :title, presence: true, length: { maximum: 100 }  
end
