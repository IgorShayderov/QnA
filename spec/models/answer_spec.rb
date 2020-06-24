# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:author) }

  it { should validate_presence_of :body }

  let!(:user) { create(:user) }
  let!(:question) { create(:question, author: user) }

  describe 'unbest_answers method' do
    it "make 'best' attribute falsy" do
      FactoryBot.create_list(:answer, 3, question: question, author: user, best: true)

      expect(Answer.first.unbest_answers).to all(have_attributes(best: false))
    end
  end
end

