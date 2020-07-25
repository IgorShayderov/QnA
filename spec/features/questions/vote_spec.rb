# frozen_string_literal: true

require 'rails_helper'

feature 'User can vote for question', "
  In order to highlight useful questions
  As an authenticated User
  I'd like to be able to vote for liked questions
" do
  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  describe 'Authenticated user', js: true do
    context 'author of question' do
      background do
        sign_in(user)
        visit question_path(question)
      end

      it 'should not be able to vote' do
        expect(page).to have_content 'Votes:'
        expect(page).to_not have_content 'Vote-for'
      end
    end

    context 'not author of the question' do
      background do
        sign_in(other_user)
        visit question_path(question)
      end

      it 'votes for the question' do
        find('.vote-for').click

        expect(page).to have_css('.question-votes-total', text: '1')
      end

      it 'votes against the question' do
        find('.vote-against').click

        expect(page).to have_css('.question-votes-total', text: '-1')
      end

      it 'cancel vote' do
        find('.vote-against').click
        find('.unvote').click

        expect(page).to have_css('.question-votes-total', text: '0')
      end

      it "can't vote more than two times" do
        find('.vote-for').click
        find('.vote-for').click

        expect(page).to have_css('.question-votes-total', text: '1')
      end
    end
  end

  describe 'Unauthenticated user' do
    it 'should not be able to vote' do
      visit question_path(question)

      expect(page).to have_content 'Votes:'
      expect(page).to_not have_content 'Vote-for'
    end
  end
end
