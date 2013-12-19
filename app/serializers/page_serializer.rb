class PageSerializer < ActiveModel::Serializer
  attributes :id, :page_id, :url, :content, :username, :published?, :created_at, :updated_at

  def username
    object.user.username
  end

end
