require 'rails_helper'

RSpec.describe QuestionUpdateJob, type: :job do
  let(:service) { double('SubscriptionService') }
  let(:answer) { create(:answer) }

  before do
    allow(SubscriptionService).to receive(:new).and_return(service)
  end

  it 'calls SubscriptionService#notificate' do
    expect(service).to receive(:notificate).with(answer)

    QuestionUpdateJob.perform_now(answer)
  end
end
