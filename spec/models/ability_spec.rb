# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user) }
    let!(:question) { create(:question, author: user) }
    let!(:other_question) { create(:question, author: other_user) }
    let!(:answer) { create(:answer, question: question, author: user) }
    let!(:other_answer) { create(:answer, question: question, author: other_user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, question }
    it { should_not be_able_to :update, other_question }
    it { should be_able_to :update, question }
    it { should_not be_able_to :update, other_question }

    it { should be_able_to :best, answer }
    it { should_not be_able_to :best, other_answer }

    it { should_not be_able_to :vote_for, answer }
    it { should be_able_to :vote_for, other_answer }
    it { should_not be_able_to :vote_against, answer }
    it { should be_able_to :vote_against, other_answer }

    describe 'unvote' do
      let(:vote) { create(:vote, user: user) }
      let(:other_vote) { create(:vote, user: other_user) }

      it { should be_able_to :unvote, vote }
      it { should_not be_able_to :unvote, other_vote }
    end

    describe 'attachments' do
      before do
        question.files.attach(create_file_blob)
        other_question.files.attach(create_file_blob)
      end

      it { should be_able_to :destroy, question.files.first }
      it { should_not be_able_to :destroy, other_question.files.first }
    end

    describe 'links' do
      let(:link) { build(:link, linkable: question) }
      let(:other_link) { build(:link, linkable: other_question) }

      it { should be_able_to :destroy, link }
      it { should_not be_able_to :destroy, other_link }
    end
  end
end
