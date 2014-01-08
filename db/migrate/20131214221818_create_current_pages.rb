class CreateCurrentPages < ActiveRecord::Migration
  def change
    create_table :current_pages do |t|
      t.integer :version_id
      t.integer :page_id
    end

    add_index :current_pages, :version_id, unique: true
    add_index :current_pages, :page_id, unique: true
  end
end
