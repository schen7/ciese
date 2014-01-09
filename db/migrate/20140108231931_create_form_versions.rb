class CreateFormVersions < ActiveRecord::Migration
  def change
    create_table :form_versions do |t|
      t.integer :form_id
      t.string :slug
      t.string :name
      t.references :user, index: true

      t.timestamps
    end
  end
end
