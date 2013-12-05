class Page < ActiveRecord::Base
  belongs_to :user
  has_one :published_page, inverse_of: :page

  def published?
    !published_page.nil?
  end
end
