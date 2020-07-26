# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    question { nil }
    body { 'MyText' }
    association :author, factory: :user

    trait :invalid do
      body { nil }
    end
  end
end
