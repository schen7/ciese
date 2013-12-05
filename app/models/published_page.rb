class PublishedPage < ActiveRecord::Base
  belongs_to :page, inverse_of: :published_page
  belongs_to :user

  validates :url, uniqueness: true
  
end
