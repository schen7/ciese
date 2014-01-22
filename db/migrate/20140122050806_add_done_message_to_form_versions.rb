class AddDoneMessageToFormVersions < ActiveRecord::Migration
  def change
    add_column :form_versions, :done_message, :text
  end
end
