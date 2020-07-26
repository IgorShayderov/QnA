# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionsChannel, type: :channel do
  it 'subscribes to stream questions' do
    subscribe

    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from('questions')
  end
end
