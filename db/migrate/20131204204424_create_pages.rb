class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :url
      t.text :content
      t.references :user, index: true

      t.timestamps
    end
  end
end
