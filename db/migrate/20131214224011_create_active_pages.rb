class CreateActivePages < ActiveRecord::Migration
  def change
    create_table :active_pages do |t|
      t.integer :version_id
      t.integer :page_id
    end

    add_index :active_pages, :version_id, unique: true
    add_index :active_pages, :page_id, unique: true
  end
end
