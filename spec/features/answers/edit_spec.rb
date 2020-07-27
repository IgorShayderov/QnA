# frozen_string_literal: true

require 'rails_helper'

feature 'Author can edit his answer', "
  In order to correct mistakes
  As an authenticated User
  I'd like to be able to edit my answers
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }

  scenario 'Unathenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit answer'
  end

  describe 'Authenticated user', js: true do
    given!(:other_user) { create(:user) }

    scenario 'edits his answer' do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit answer'

      within '.answers' do
        fill_in 'Edited answer', with: 'edited answer'
        click_on 'Edit the answer'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
      end
    end

    scenario 'edits his answer by attaching files' do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        click_on 'Edit answer'
        attach_file ["#{Rails.root}/spec/rails_helper.rb"]
        click_on 'Edit the answer'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link '(Delete)'
      end
    end

    scenario 'edits his answer with errors' do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit answer'

      within '.answers' do
        fill_in 'Edited answer', with: ''
        click_on 'Edit the answer'
      end

      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries to edit other user's answer" do
      sign_in(other_user)
      visit question_path(question)

      expect(page).to_not have_link 'Edit answer'
    end
  end
end
