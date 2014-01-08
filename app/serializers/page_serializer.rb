class PageSerializer < ActiveModel::Serializer
  attributes :id, :page_id, :url, :title, :content, :username, :published?, :date

  def username
    object.user.username
  end

end
