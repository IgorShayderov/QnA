class DailyDigestPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/daily_digest/digest
  def digest
    DailyDigestMailer.with(user: User.first).digest
  end
end
