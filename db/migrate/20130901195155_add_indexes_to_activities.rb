class AddIndexesToActivities < ActiveRecord::Migration
  def change
    add_index :activities, :program
    add_index :activities, :detail
  end
end
