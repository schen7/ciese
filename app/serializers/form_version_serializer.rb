class FormVersionSerializer < ActiveModel::Serializer
  attributes :id, :form_id, :project, :name, :done_message, :username, :published, :date
  has_many :fields

  def published
    object.published?
  end

  def username
    object.user.username unless object.user.nil?
  end
end
