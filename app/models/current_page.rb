class CurrentPage < ActiveRecord::Base

  belongs_to :version, class_name: "Page", foreign_key: "version_id", inverse_of: :current_page

  scope :with_publish_info, -> {
    joins("LEFT OUTER JOIN published_pages ON published_pages.page_id = current_pages.page_id")
    .select(
      "current_pages.*, " +
      "published_pages.version_id IS NOT NULL AND published_pages.version_id = current_pages.version_id as published, " +
      "published_pages.version_id IS NOT NULL AND published_pages.version_id != current_pages.version_id as prev_published"
    )
  }

end
