FactoryGirl.define do
  factory :form_version do
    form_id nil
    slug { name.parameterize }
    sequence(:name) { |n| "Form #{n}" }
    association :user, strategy: :build

    after(:create) do |form_version|
      if form_version.form_id.nil?
        form_version.form_id = form_version.id
        form_version.save
      end
    end
  end
end

