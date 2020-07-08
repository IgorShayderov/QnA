# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:author) }
  it { should have_many(:links).dependent(:destroy) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  let!(:user) { create(:user) }
  let!(:question) { create(:question, author: user) }
  let!(:answer) { create(:answer, question: question, author: user) }

  describe 'make_best method' do
    it "make 'best' attribute true for certain answer" do
      answer.make_best

      expect(answer).to be_best
    end

    it "make 'best' attribute falsy for other answers" do
      create_list(:answer, 3, question: question, author: user, best: true)

      answer.make_best

      expect(question.answers.where.not(id: answer)).to all(have_attributes(best: false))
    end
  end
end
