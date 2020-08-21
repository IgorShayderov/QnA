# frozen_string_literal: true

class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  before_action :get_question, only: %i[show edit update destroy]
  after_action :publish_question, only: %i[create]

  def index
    authorize! :index, Question
    @questions = Question.all
  end

  def show
    authorize! :show, Question
    @answer = @question.answers.new
    @subscription = @question.subscriptions.find_by(user_id: current_user&.id)
    gon.push({ question_id: @question.id,
               user_id: user_signed_in? ? current_user.id : 0 })
  end

  def new
    @question = Question.new
    authorize! :new, @question
    @question.build_reward
  end

  def edit; end

  def create
    authorize! :create, Question
    @question = current_user.questions.new(question_params)

    if @question.save
      @question.subscriptions.create!(user: @question.author)
      redirect_to @question, notice: 'Your question has been successfully created'
    else
      render :new
    end
  end

  def update
    authorize! :update, @question
    @question.update(question_params)
  end

  def destroy
    authorize! :destroy, @question
    @question.destroy
    redirect_to questions_path
  end

  private

  def get_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(
      :title,
      :body,
      files: [],
      links_attributes: %i[id name url _destroy],
      reward_attributes: %i[name image]
    )
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast('questions',
                                 ApplicationController.render(
                                   partial: 'questions/question',
                                   locals: { question: @question }
                                 ))
  end
end
