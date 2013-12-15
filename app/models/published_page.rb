class PublishedPage < ActiveRecord::Base

  belongs_to :version, class_name: "Page", foreign_key: "version_id", inverse_of: :published_page

end
