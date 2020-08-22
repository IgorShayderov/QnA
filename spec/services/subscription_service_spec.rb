require 'rails_helper'

RSpec.describe SubscriptionService do
  let!(:subscribed_users) { create_list(:user, 3) }
  let(:unsubscribed_users) { create_list(:user, 3) }
  let!(:question) { create(:question) }

  before do
    subscribed_users.each do |user|
      create(:subscription, question: question, user: user)
    end
  end

  let!(:answer) { create(:answer, question: question) }

  it 'sends new asnwer notification to all subscribed users' do
    subscribed_users.each do |user|
      expect(NewAnswerNotificationMailer)
        .to receive(:send_notification)
        .with(user, answer)
        .and_call_original
    end

    subject.notificate(answer)
  end

  it 'does not sends new asnwer notification to unsubscribed users' do
    expect(NewAnswerNotificationMailer).to receive(:send_notification).exactly(3).times.and_call_original

    subject.notificate(answer)
  end
end
