# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Associations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
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
end
