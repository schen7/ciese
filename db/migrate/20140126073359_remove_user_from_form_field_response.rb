class RemoveUserFromFormFieldResponse < ActiveRecord::Migration
  def change
    remove_column :form_field_responses, :user_id, :integer
  end
end
