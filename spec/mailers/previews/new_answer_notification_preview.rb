# Preview all emails at http://localhost:3000/rails/mailers/new_answer_notification
class NewAnswerNotificationPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/new_answer_notification/send_notification
  def send_notification
    NewAnswerNotificationMailer.send_notification
  end

end
