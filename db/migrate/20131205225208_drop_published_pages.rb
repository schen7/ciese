class DropPublishedPages < ActiveRecord::Migration
  def change
    drop_table :published_pages
  end
end
