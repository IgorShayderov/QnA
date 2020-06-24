# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'

  validates :body, presence: true

  def unbest_answers
    question.answers.each{|answer| answer.update_attribute(:best, false)}
  end
end
