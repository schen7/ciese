class RenameActivePagesToPublishedPages < ActiveRecord::Migration
  def change
    rename_table :active_pages, :published_pages
  end
end
