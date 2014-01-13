FactoryGirl.define do
  factory :form_field do
    association :form_version, factory: :form_version, strategy: :create
    kind { FormField::KINDS.sample }
    details ""
  end
end

