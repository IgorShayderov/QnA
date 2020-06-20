class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :get_question, only: %i[create]
  before_action :get_answer, only: %i[edit update destroy]

  def create
    @answer = @question.answers.create(answer_params.merge(author: current_user))
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
    redirect_to @answer.question
  end

  private

  def get_question
    @question = Question.find(params[:question_id])
  end

  def get_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
