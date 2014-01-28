FactoryGirl.define do
  factory :form_field do
    association :form_version, factory: :form_version, strategy: :create
    kind { FormField::KINDS.sample }
    details { {} }

    factory :info_field do
      kind "info"
      details text: "Information text."
    end

    factory :short_answer_field do
      kind "short-answer"
      details question: "What is the answer?", label: "Answer"
    end

    factory :long_answer_field do
      kind "long-answer"
      details question: "What is the answer?", label: "Answer"
    end

    factory :single_choice_field do
      kind "single-choice"
      details question: "Which choice is correct?", choices: [
        { label: "A" }, { label: "B" }, { label: "C" }
      ]
    end

    factory :multiple_choice_field do
      kind "multiple-choice"
      details question: "Which choices are correct?", choices: [
        { label: "A" }, { label: "B" }, { label: "C" }
      ]
    end

    factory :address_field do
      kind "address"
      details question: "Enter your address"
    end
  end
end

