require 'rails_helper'

feature 'User can create answer to question', %q{
  In order to help other users
  As an User
  I'd like to be able to create answer to the question
} do

  given(:question) { create(:question) }
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'User create answer' do
      fill_in 'Your answer', with: 'My answer'
      click_on 'Answer the question'

      expect(page).to have_content 'My answer'
    end

    scenario 'User create invalid answer' do
      click_on 'Answer the question'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit question_path(question)

    expect(page).to_not have_content 'Answer the question'
  end
end