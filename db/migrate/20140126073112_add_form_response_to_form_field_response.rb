class AddFormResponseToFormFieldResponse < ActiveRecord::Migration
  def change
    add_column :form_field_responses, :form_response_id, :integer
  end
end
