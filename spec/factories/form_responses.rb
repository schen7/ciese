FactoryGirl.define do
  factory :form_response do
    association :form_field, factory: :form_field, strategy: :create
    form_version { form_field.form_version }
    form_id { form_version.form_id }
    association :user, strategy: :build
    details { {} }
  end
end


