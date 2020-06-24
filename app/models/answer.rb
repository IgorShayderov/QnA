# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'

  validates :body, presence: true

  scope :sorted_answers, ->(question) { where(question: question).order(best: :desc, created_at: :desc) }

  def make_best(params)
    process_best_answer(params) if !best?
  end

  private

  def process_best_answer(params)
    Answer.transaction do
      question.answers.where(best: true).update_all(best: false)
      update(params)
    end
  end
end
