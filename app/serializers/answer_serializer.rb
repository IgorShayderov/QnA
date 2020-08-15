class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at

  has_many :links
  has_many :votes
  has_many :comments
  has_many :files, serializer: AttachmentSerializer

  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
end
