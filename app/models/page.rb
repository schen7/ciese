class Page < ActiveRecord::Base

  belongs_to :user
  has_one :current_page, foreign_key: "version_id", inverse_of: :version
  has_one :published_page, foreign_key: "version_id", inverse_of: :version

  validates :url, presence: true, format: { 
    with: /\A(?:\/|(?:(?:\/[~%\+\-\.\w]+)+\/?))\z/, message: "Not a valid url."
  }
  validates :user, presence: true

  before_save do |page|
    page.url = page.url.chomp("/") if page.url != '/'
  end

  after_save do |page|
    page.update(page_id: page.id) if page.page_id.nil?
  end

  def published?
    !published_page.nil?
  end

  def date
    updated_at.to_formatted_s(:simple)
  end

end
