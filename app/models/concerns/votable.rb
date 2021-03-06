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

  def unvote(vote)
    vote.destroy
  end

  def votes_total
    votes.sum(:value)
  end

  private

  def make_vote(user, value)
    votes.new(
      {
        user: user,
        value: value
      }
    )
  end
end
