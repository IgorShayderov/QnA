# frozen_string_literal: true

class Answer < ApplicationRecord
  include Votable
  include Commentable

  has_many :links, dependent: :destroy, as: :linkable
  belongs_to :question
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

  scope :sorted_answers, ->(question) { where(question: question).order(best: :desc, created_at: :asc) }

  ThinkingSphinx::Callbacks.append(
    self, behaviours: [:sql]
  )

  def make_best
    return if best?

    Answer.transaction do
      question.answers.where(best: true).update_all(best: false)
      update!(best: true)
      question.reward&.update!(user: author)
    end
  end
end
