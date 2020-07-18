# frozen_string_literal: true

module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def vote_for(user)
    make_vote(user, 1)
  end

  def vote_against(user)
    make_vote(user, -1)
  end

  def unvote(user)
    votes.where(user: user).select(:id).destroy_all
  end

  def votes_total
    votes.sum(:value)
  end

  private

  def make_vote(user, value)
    votes.create!(
      {
        user: user,
        value: value
      }
    )
  end
end
