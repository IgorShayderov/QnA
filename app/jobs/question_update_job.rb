class QuestionUpdateJob < ApplicationJob
  queue_as :default

  def perform(answer)
    SubscriptionService.new.notificate(answer)
  end
end
