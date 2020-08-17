# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    for_question

    body { 'Comment' }
    association :user

    trait :for_question do
      association :commentable, factory: :question
    end

    trait :for_answer do
      association :commentable, factory: :answer
    end

    trait :invalid do
      body { nil }
    end
  end
end
