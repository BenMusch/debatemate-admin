require "factory_girl"

FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    email { "#{name.split(" ").join("")}@example.com" }
    phone { Faker::Base.numerify("#{"#" * 10}") }
    admin false
    password "password"
    password_confirmation "password"

    trait :admin do
      admin true
      email { "#{name.split(" ").join("")}@debatemate.com" }
    end

    trait :activated do
      activated true
      activated_at 10.days.ago
    end

    trait :monday do
      monday true
    end

    trait :tuesday do
      tuesday true
    end

    trait :wednesday do
      wednesday true
    end

    trait :thursday do
      thursday true
    end

    trait :friday do
      friday true
    end
  end

  factory :school do
    name { Faker::Address.city + " High School" }
  end

  factory :lesson do
    date { Date.today }
    association :school, factory: :school
    association :users, factory: :user

    trait :future do
      date { Date.today + 10.days }
    end

    trait :past do
      date { 10.days.ago }
    end
  end

  factory :goal do
    text "This is a goal"
    association :user, factory: :user
  end
end
