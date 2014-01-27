FactoryGirl.define do
  factory :form_version do
    form_id nil
    project Ciese::PROJECTS.keys.sample
    slug { name.parameterize }
    sequence(:name) { |n| "Form #{n}" }
    done_message "Thank you for submitting this form."
    association :user, strategy: :build

    after(:create) do |form_version|
      if form_version.form_id.nil?
        form_version.form_id = form_version.id
        form_version.save
      end
    end

    factory :form_version_with_fields do
      after(:create) do |form_version|
        create(:info_field, form_version: form_version)
        create(:short_answer_field, form_version: form_version)
        create(:long_answer_field, form_version: form_version)
        create(:single_choice_field, form_version: form_version)
        create(:multiple_choice_field, form_version: form_version)
      end
    end
  end
end

