class RenameFormResponseToFormFieldResponse < ActiveRecord::Migration
  def change
    rename_table :form_responses, :form_field_responses
  end
end
