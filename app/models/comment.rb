class Comment < ActiveRecord::Base
  class NotLoggedIn < StandardError; end
  class NotAuthorized < StandardError; end

  belongs_to :post
  #belongs_to :user
  validates :post_id, presence: true
  validates :author, presence: true
  validates :content, presence: true 
end
