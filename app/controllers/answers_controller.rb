# frozen_string_literal: true

class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :get_question, only: %i[create]
  before_action :get_answer, only: %i[edit update destroy best]
  after_action :publish_answer, only: %i[create]

  def create
    authorize! :create, Answer
    @answer = @question.answers.create(answer_params.merge(author: current_user))
  end

  def update
    authorize! :update, @answer
    @answer.update(answer_params) if current_user&.author_of?(@answer)
  end

  def destroy
    authorize! :destroy, @answer
    @answer.destroy if current_user&.author_of?(@answer)
  end

  def best
    authorize! :best, @answer
    @answer.make_best if current_user&.author_of?(@answer.question)
  end

  private

  def get_question
    @question = Question.find(params[:question_id])
  end

  def get_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[id name url _destroy])
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast("questions/#{@answer.question_id}/answers", {
                                   answer: @answer,
                                   links: @answer.links,
                                   files: @answer.files.to_a
                                 })
  end
end
