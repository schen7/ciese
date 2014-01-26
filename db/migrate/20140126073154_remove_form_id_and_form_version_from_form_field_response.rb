class RemoveFormIdAndFormVersionFromFormFieldResponse < ActiveRecord::Migration
  def change
    remove_column :form_field_responses, :form_id, :integer
    remove_column :form_field_responses, :form_version_id, :integer
  end
end
