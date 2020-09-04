class Subscription < ApplicationRecord
  belongs_to :question, touch: true
  belongs_to :user
  validates :user, uniqueness: { scope: :question_id }
end
