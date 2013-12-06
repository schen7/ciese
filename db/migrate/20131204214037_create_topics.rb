class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :name
      t.integer :board_id

      t.timestamps
    end
    add_index :topics, [:board_id, :created_at]
  end
end
