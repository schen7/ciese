class CreateFormResponses2 < ActiveRecord::Migration
  def change
    create_table :form_responses do |t|
      t.integer :form_id
      t.integer :form_version_id
      t.integer :user_id
    end
  end
end
