class FormVersionSerializer < ActiveModel::Serializer
  attributes :form_version_id, :form_id, :name, :username, :published, :date
  has_many :fields

  def form_version_id
    object.id
  end

  def published
    object.published?
  end

  def username
    object.user.username unless object.user.nil?
  end
end
