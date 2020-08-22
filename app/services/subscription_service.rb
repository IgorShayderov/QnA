class SubscriptionService
  def notificate(answer)
    answer.question.subscribers.find_each(batch_size: 500) do |user|
      NewAnswerNotificationMailer.send_notification(user, answer).deliver_later
    end
  end
end
