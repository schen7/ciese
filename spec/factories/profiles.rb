FactoryGirl.define do
  factory :profile do
    association :user, factory: :user, strategy: :build
    first_name { Faker::Name.first_name }
    middle_name { "#{('A'..'Z').to_a.sample}." }
    last_name { Faker::Name.last_name }
    sequence(:ciese_id) { |n| n }
    prefix { Faker::Name.prefix }
    title { Faker::Name.title }
    greeting ""
    ssn { Faker::Number.number(9) }
    email1 { Faker::Internet.email }
    email2 { Faker::Internet.email }
    department { ["Science", "Math", "Social Studies", "Language Arts", "Music",
                  "Art", "Sports", "Foreign Language"].sample }
    subject { ["Physics", "Chemistry", "Biology", "Algebra I", "Algebra II",
               "Trigonometry", "Calculus", "English", "Spanish", "German"].sample }
    grade { (1..12).to_a.sample.to_s }
    function ""
    district { Faker::Address.city }
    affiliation "Affiliation"
    address_line_1 { Faker::Address.street_address }
    address_line_2 { Faker::Address.secondary_address }
    city { Faker::Address.city }
    state { Faker::Address.state }
    zip { Faker::Address.zip_code }
    country { Faker::Address.country }
    phone1 { Faker::PhoneNumber.phone_number }
    phone2 { Faker::PhoneNumber.phone_number }
    fax { Faker::PhoneNumber.phone_number }
    home_address_line_1 { Faker::Address.street_address }
    home_address_line_2 { Faker::Address.secondary_address }
    home_city { Faker::Address.city }
    home_state { Faker::Address.state }
    home_zip { Faker::Address.zip_code }
    home_phone { Faker::PhoneNumber.phone_number }
    home_mobile { Faker::PhoneNumber.cell_phone }
    home_fax { Faker::PhoneNumber.phone_number }
    memo1 { Faker::Lorem.paragraph }
    memo2 { Faker::Lorem.paragraph }
    memo3 { Faker::Lorem.paragraph }

    factory :profile_with_activities do

      ignore do
        activity_count 3
      end

      after(:create) do |profile, evaluator|
        create_list(:activity, evaluator.activity_count, profile: profile)
      end
    end
  end
end
