class NewAnswerNotificationMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.new_answer_notification_mailer.send_notification.subject
  #
  def send_notification(user, answer)
    @answer = answer

    mail(to: user.email, subject: 'Question have new answers')
  end
end
