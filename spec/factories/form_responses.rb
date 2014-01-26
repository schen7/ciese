FactoryGirl.define do
  factory :form_response do
    association :form_version, factory: :form_version, strategy: :create
    form_id { form_version.form_id }
    association :user, strategy: :build
  end
end
