class RemoveLastestAndPublishedFromPages < ActiveRecord::Migration
  def change
    remove_column :pages, :latest, :boolean
    remove_column :pages, :published, :boolean
  end
end
