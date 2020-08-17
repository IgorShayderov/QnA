# frozen_string_literal: true

class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :short_title

  has_many :answers
  has_many :links
  has_many :votes
  has_many :comments
  has_many :files, serializer: AttachmentSerializer

  belongs_to :author, class_name: 'User', foreign_key: 'user_id'

  def short_title
    object.title.truncate(7)
  end
end
