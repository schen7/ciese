class CreateFormResponses < ActiveRecord::Migration
  def change
    create_table :form_responses do |t|
      t.integer :form_id
      t.references :form_version, index: true
      t.references :form_field, index: true
      t.references :user, index: true
      t.text :details

      t.timestamps
    end
  end
end
