# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :get_question, only: %i[create]
  before_action :get_answer, only: %i[edit update destroy best delete_file]

  def create
    @answer = @question.answers.create(answer_params.merge(author: current_user))
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
  end

  def best
    @answer.make_best if current_user.author_of?(@answer.question)
  end

  def delete_file
    @answer.files.find(params[:file_id]).purge
  end

  private

  def get_question
    @question = Question.find(params[:question_id])
  end

  def get_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [])
  end
end
