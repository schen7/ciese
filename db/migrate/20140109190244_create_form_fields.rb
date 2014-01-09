class CreateFormFields < ActiveRecord::Migration
  def change
    create_table :form_fields do |t|
      t.references :form_version, index: true
      t.string :kind
      t.boolean :required
      t.text :details
    end
  end
end
