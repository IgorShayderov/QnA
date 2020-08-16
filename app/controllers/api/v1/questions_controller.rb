class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_question, only: %i[update destroy]
  authorize_resource

  def index
    @questions = Question.with_attached_files.all
    render json: @questions
  end

  def show
    @question = Question.with_attached_files.find(params[:id])

    render json: @question
  end

  def create
    @question = current_resource_owner.questions.new(question_params)

    if @question.save
      render json: @question, status: :created
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @question.update(question_params)
      render json: @question, status: :accepted
    else
      render json: { errors: @question.errors }, status: :unproccessable_entity
    end
  end

  def destroy
    if @question.destroy
      render json: {}, status: :ok
    else
      render json: { errors: @question.errors }, status: :uproccessable_entity
    end
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(
      :title,
      :body,
      links_attributes: %i[id name url _destroy]
    )
  end
end
