class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def create
    @question = Question.find(params[:question_id])
    @question.subscriptions.new(user: current_user)

    if @question.save
      redirect_to @question, notice: 'Your have successfully subscribed'
    else
      redirect_to @question, alert: 'There is some kind of error'
    end
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    redirect_to @subscription.destroy.question
  end
end
