FactoryBot.define do
  factory :vote do
    count { 1 }
    votable_type { "MyString" }
    votable_id { "MyString" }
    integer { "MyString" }
  end
end
