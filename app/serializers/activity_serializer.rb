class ActivitySerializer < ActiveModel::Serializer
  attributes :id, :program, :detail, :start_date, :end_date
end
