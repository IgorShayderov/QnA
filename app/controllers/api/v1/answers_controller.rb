class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource

  def index
    @answers = Question.find(params[:question_id]).answers
    render json: @answers
  end

  def show
    @answer = Answer.find(params[:id])
    render json: @answer
  end
end
