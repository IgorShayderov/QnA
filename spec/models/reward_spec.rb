# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reward, type: :model do
  it { should validate_presence_of :name }

  it 'have many attached files' do
    expect(Reward.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
