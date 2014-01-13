class RemoveRequiredFromFormFields < ActiveRecord::Migration
  def change
    remove_column :form_fields, :required, :boolean
  end
end
