# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[github]
  has_many :questions
  has_many :answers
  has_many :rewards
  has_many :authorizations, dependent: :destroy

  def author_of?(element)
    id == element.user_id
  end

  def self.find_for_oauth(auth)
    FindForOauth.new(auth).call
  end
end
