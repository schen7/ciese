class AddLatestAndPublishedToPages < ActiveRecord::Migration
  def change
    add_column :pages, :latest, :boolean
    add_column :pages, :published, :boolean
  end
end
