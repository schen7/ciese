class AddProgramToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :program, :string
  end
end
