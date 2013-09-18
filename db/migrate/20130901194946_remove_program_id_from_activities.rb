class RemoveProgramIdFromActivities < ActiveRecord::Migration
  def change
    remove_column :activities, :program_id, :integer
  end
end
