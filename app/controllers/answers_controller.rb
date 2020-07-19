# frozen_string_literal: true

class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :get_question, only: %i[create]
  before_action :get_answer, only: %i[edit update destroy best]

  def create
    @answer = @question.answers.create(answer_params.merge(author: current_user))

    respond_to do |format|
      if @answer.save
        format.json { render json: { answer: @answer, is_author: current_user&.author_of?(@answer), links: @answer.links } }
      else
        format.json { render json: @answer.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def update
    @answer.update(answer_params) if current_user&.author_of?(@answer)
  end

  def destroy
    @answer.destroy if current_user&.author_of?(@answer)
  end

  def best
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
end
