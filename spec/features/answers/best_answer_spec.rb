# frozen_string_literal: true

require 'rails_helper'

feature 'Author can choose best answers', "
  In order to mark most helpful answer
  As an Author of answer
  I'd like to be able to choose best answer
" do
  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, author: user, question: question) }
  given!(:other_answer) { create(:answer, author: user, question: question) }
  given(:answer_tag) { "[data-answer-id='#{answer.id}']" }
  given(:other_answer_tag) { "[data-answer-id='#{other_answer.id}']" }

  describe 'As authenticated user', js: true do
    context 'Author can' do
      background do
        sign_in(user)
        visit question_path(question)
      end

      it 'choose best answer' do
        within answer_tag do
          click_link 'Choose as best answer'
        end

        expect(page).to have_css "#{answer_tag}.best"
      end

      it 'change best answer' do
        within answer_tag do
          click_link 'Choose as best answer'
        end
        within other_answer_tag do
          click_link 'Choose as best answer'
        end

        expect(page).to have_css "#{other_answer_tag}.best"
      end

      it 'choose only one best answer' do
        within answer_tag do
          click_link 'Choose as best answer'
        end
        within other_answer_tag do
          click_link 'Choose as best answer'
        end

        expect(page).to have_selector('.best', count: 1)
      end
    end

    context 'User who is not the author' do
      it 'can not choose best answer' do
        sign_in(other_user)
        visit question_path(question)

        expect(page).to_not have_link 'Choose as best answer'
      end
    end

    scenario 'Best answer must be first in answers list' do
      sign_in(user)
      create_list(:answer, 3, question: question, author: user)
      visit question_path(question)

      within answer_tag do
        click_link 'Choose as best answer'
      end

      expect(find("#{answer_tag}.best")).to eq first('.answer')
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can not choose best answer' do
      visit question_path(question)

      expect(page).to_not have_link 'Choose as best answer'
    end
  end
end
