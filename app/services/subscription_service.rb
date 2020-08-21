class SubscriptionService
  def notificate(answer)
    User.joins(:subscriptions).where(subscriptions: { question_id: answer.question.id }).find_each(batch_size: 500) do |user|
      NewAnswerNotificationMailer.send_notification(user, answer).deliver_later
    end
  end
end
