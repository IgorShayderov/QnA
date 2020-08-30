# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: %{"QnA" <app.mailer.simple@gmail.com>}
  layout 'mailer'
end
