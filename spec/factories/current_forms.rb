FactoryGirl.define do
  factory :current_form do
    form_id { form_version.form_id }
    association :form_version, factory: :form_version, strategy: :create
    slug { form_version.slug }
  end
end
