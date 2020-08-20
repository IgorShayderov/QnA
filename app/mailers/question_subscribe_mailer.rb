class QuestionSubscribeMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.question_subscribe_mailer.update_question.subject
  #
  def update_question
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
