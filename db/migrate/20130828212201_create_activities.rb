class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :profile_id
      t.integer :program_id
      t.string :detail
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end
  end
end
