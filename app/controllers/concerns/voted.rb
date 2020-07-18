# frozen_string_literal: true

module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[vote_for vote_against unvote]
  end

  def vote_for
    unless current_user&.author_of?(@votable)
      @votable.vote_for(current_user)
      make_respond
    end
  end

  def vote_against
    unless current_user&.author_of?(@votable)
      @votable.vote_against(current_user)
      make_respond
    end
  end

  def unvote
    unless current_user&.author_of?(@votable)
      @votable.unvote(current_user)
      make_respond
    end
  end

  private

  def make_respond
    respond_to do |format|
      if @votable.save
        format.json { render json: { id: @votable.id, resource: votable_class, votes_total: @votable.votes_total } }
      else
        format.json { render json: { errors: @votable.errors.full_messages, resource: votable_class }, status: :unprocessable_entity }
      end
    end
  end

  def votable_class
    @votable.class.name.underscore
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end
