class AddProjectToFormVersions < ActiveRecord::Migration
  def change
    add_column :form_versions, :project, :string
  end
end
