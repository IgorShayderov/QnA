# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'

  has_many_attached :files

  validates :body, presence: true

  scope :sorted_answers, ->(question) { where(question: question).order(best: :desc, created_at: :asc) }

  def make_best
    if !best?
      Answer.transaction do
        question.answers.where(best: true).update_all(best: false)
        update!(best: true)
      end
    end
  end
end
