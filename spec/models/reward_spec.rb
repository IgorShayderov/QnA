require 'rails_helper'

RSpec.describe Reward, type: :model do
  it { should validate_presence_of :name }

  it 'have many attached files' do
    expect(Reward.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
