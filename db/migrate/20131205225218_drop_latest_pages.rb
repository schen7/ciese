class DropLatestPages < ActiveRecord::Migration
  def change
    drop_table :latest_pages
  end
end
