class RemoveStartAndEndDatesFromActivities < ActiveRecord::Migration
  def change
    remove_column :activities, :start_date, :datetime
    remove_column :activities, :end_date, :datetime
  end
end
