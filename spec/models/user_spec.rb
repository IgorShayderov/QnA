# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Associations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
    it { should have_many(:authorizations).dependent(:destroy) }
    it { should have_many(:subscriptions).dependent(:destroy) }
  end

  describe '#author_of' do
    let(:user) { create(:user) }
    let!(:other_user) { create(:user) }
    let(:element) { create(:question, author: user) }

    it 'return true while User is author of element' do
      expect(user).to be_author_of(element)
    end

    it 'return false while User is not author of element' do
      expect(other_user).to_not be_author_of(element)
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('FindForOauth') }

    it 'calls FindForOauth' do
      expect(FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end
end
