# frozen_string_literal: true

require 'rails_helper'

feature 'Author can edit his question', "
  In order to correct mistakes
  As an authenticated User
  I'd like to be able to edit my questions
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  scenario 'Unathenticated user can not edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

  describe 'Authenticated user', js: true do
    given!(:other_user) { create(:user) }

    scenario 'edits his answer' do
      sign_in(user)
      visit question_path(question)

      within '.question' do
        click_on 'Edit question'
        fill_in 'Edit question text', with: 'edited question'
        click_on 'Edit the question'

        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited question'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his question by attaching files' do
      sign_in(user)
      visit question_path(question)

      within '.question' do
        click_link 'Edit question'
        attach_file "#{Rails.root}/spec/rails_helper.rb"
        click_on 'Edit the question'

        expect(page).to have_link 'rails_helper.rb'
      end
    end

    scenario 'edits his question with errors' do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit question'

      within '.question' do
        fill_in 'Edit question text', with: ''
        click_on 'Edit the question'
      end

      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries to edit other user's answer" do
      sign_in(other_user)
      visit question_path(question)

      expect(page).to_not have_link 'Edit question'
    end
  end
end
