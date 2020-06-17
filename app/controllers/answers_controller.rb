class AnswersController < ApplicationController
  before_action :get_question, only: %i[create]
  before_action :get_answer, only: %i[edit update destroy]
  before_action :authenticate_user!, only: %i[create update destroy]

  def create
    @answer = @question.answers.new(answer_params)

    if @answer.save
      redirect_to @question
    else
      render 'questions/show'
    end
  end

  def update
    if @answer.update(answer_params)
      redirect_to @answer
    else
      render 'questions/show'
    end
  end

  def destroy
    @answer.destroy
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
