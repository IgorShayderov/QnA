# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:author) }

  it { should validate_presence_of :body }

  let!(:user) { create(:user) }
  let!(:question) { create(:question, author: user) }
  let!(:answer) { create(:answer, question: question, author: user) }

  describe 'make_best method' do
    it "make 'best' attribute true for certain answer" do
      answer.make_best({best: true})

      expect(answer.best?).to eq true
    end

    it "make 'best' attribute falsy for other answers" do
      create_list(:answer, 3, question: question, author: user, best: true)

      answer.make_best({best: true})

      expect(question.answers.where.not(id: answer)).to all(have_attributes(best: false))
    end
  end
end

