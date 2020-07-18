# frozen_string_literal: true

module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[vote_for vote_against unvote]
  end

  def vote_for
    @votable.vote_for(current_user)
  end

  def vote_against
    @votable.vote_against(current_user)
  end

  def unvote
    @votable.unvote(current_user)
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end
