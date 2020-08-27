# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: %i[github vkontakte]
  has_many :questions
  has_many :answers
  has_many :rewards
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  ThinkingSphinx::Callbacks.append(
    self, behaviours: [:sql]
  )

  def author_of?(element)
    id == element.user_id
  end

  def self.find_for_oauth(auth)
    FindForOauth.new(auth).call
  end

  def subscribed?(question)
    subscriptions.exists?(question_id: question.id)
  end
end
