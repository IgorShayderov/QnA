# frozen_string_literal: true

FactoryBot.define do
  factory :link do
    for_question

    name { 'MyString' }
    url { 'https://www.google.com' }

    trait :for_question do
      association :linkable, factory: :question
    end

    trait :for_answer do
      association :linkable, factory: :answer
    end
  end
end
