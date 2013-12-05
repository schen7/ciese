class CreatePublishedPages < ActiveRecord::Migration
  def change
    create_table :published_pages do |t|
      t.string :url
      t.references :page, index: true
      t.references :user, index: true
      
      t.timestamps
    end

    add_index :published_pages, :url, unique: true
  end
end
