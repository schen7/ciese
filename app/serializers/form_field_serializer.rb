class FormFieldSerializer < ActiveModel::Serializer
  attributes :id, :form_version_id, :kind, :details
end
