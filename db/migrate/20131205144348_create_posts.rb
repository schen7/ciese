class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :topic_id
      t.string :title
      t.text :content
      t.integer :author

      t.timestamps
    end
    add_index :posts, [:topic_ic, :created_at]
  end
end
