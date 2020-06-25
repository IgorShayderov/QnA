# frozen_string_literal: true

require 'rails_helper'

feature 'User can create answer to question', "
  In order to help other users
  As an User
  I'd like to be able to create answer to the question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'create answer' do
      fill_in 'New answer', with: 'My answer'
      click_on 'Answer the question'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'My answer'
      end
    end

    scenario 'create invalid answer' do
      click_on 'Answer the question'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit question_path(question)

    expect(page).to_not have_content 'Answer the question'
  end
end
