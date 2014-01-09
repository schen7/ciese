class CreateCurrentForms < ActiveRecord::Migration
  def change
    create_table :current_forms do |t|
      t.integer :form_id, index: true
      t.references :form_version, index: true
      t.string :slug, index: true

      t.timestamps
    end
  end
end
