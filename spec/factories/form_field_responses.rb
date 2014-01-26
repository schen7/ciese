FactoryGirl.define do
  factory :form_field_response do
    association :form_response, factory: :form_response, strategy: :create
    association :form_field, factory: :form_field, strategy: :create
    details { {} }
  end
end
