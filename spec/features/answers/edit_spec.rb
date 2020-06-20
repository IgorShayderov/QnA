require 'rails_helper'

feature 'Author can edit his answer', %q{
  In order to correct mistakes
  As an authenticated User
  I'd like to be able to edit my answers
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }

  scenario 'Unathenticated user cant not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edits his answer', js: true do
      sign_in(user)
      visit question_path(question)

      click_on 'Edit answer'

      within '.answers' do
        fill_in 'Edited answer', with: 'edited answer'
        click_on 'Edit the answer'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors'
    scenario "tries to edit other user's answer"
  end
end