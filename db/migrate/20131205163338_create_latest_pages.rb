class CreateLatestPages < ActiveRecord::Migration
  def change
    create_table :latest_pages do |t|
      t.string :url
      t.references :page, index: true
    end

    add_index :latest_pages, :url, unique: true
  end
end
