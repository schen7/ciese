FactoryGirl.define do
  factory :program do
    sequence(:name) { |n| "Program #{n}" }
    sequence(:details) { |n| ["Detail #{n}a", "Detail #{n}b", "Detail #{n}c"] }
  end
end
