FactoryBot.define do
  factory :vote do
    for_question # default to the :for_photo trait if none is specified

    value { 1 }
    association :user, factory: :user

    trait :for_question do
      association :votable, factory: :question
    end

    trait :for_answer do
      association :votable, factory: :answer
    end
  end
end
