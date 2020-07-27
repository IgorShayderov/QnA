# frozen_string_literal: true

require 'rails_helper'

feature 'User can vote for answer', "
  In order to highlight useful answers
  As an authenticated User
  I'd like to be able to vote for liked answers
" do
  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }

  describe 'Authenticated user', js: true do
    context 'author of answer' do
      background do
        sign_in(user)
        visit question_path(question)
      end

      it 'should not be able to vote' do
        within '.answers' do
          expect(page).to have_content 'Votes:'
          expect(page).to_not have_content 'Vote-for'
        end
      end
    end

    context 'not author of the answer' do
      background do
        sign_in(other_user)
        visit question_path(question)
      end

      it 'votes for the answer' do
        within '.answers' do
          find('.vote-for').click
        end

        expect(page).to have_css('.answer-votes-total', text: '1')
      end

      it 'votes against the answer' do
        within '.answers' do
          find('.vote-against').click
        end

        expect(page).to have_css('.answer-votes-total', text: '-1')
      end

      it 'cancel vote' do
        within '.answers' do
          find('.vote-against').click
          find('.unvote').click
        end

        expect(page).to have_css('.answer-votes-total', text: '0')
      end

      it "can't vote more than two times" do
        within '.answers' do
          find('.vote-for').click
          find('.vote-for').click
        end

        expect(page).to have_css('.answer-votes-total', text: '1')
      end
    end
  end

  describe 'Unauthenticated user' do
    it 'should not be able to vote' do
      visit question_path(question)

      within '.answers' do
        expect(page).to have_content 'Votes:'
        expect(page).to_not have_content 'Vote-for'
      end
    end
  end
end
