# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :value, presence: true, inclusion: { in: [1, -1] }
  validates :user, uniqueness: { scope: :votable_id }
end
