# frozen_string_literal: true

require 'rails_helper'

feature 'Author can delete attached files from questions', "
  In order to remove unnecessary files
  As an Author of question
  I'd like to delete attached files
" do
  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  before do
    sign_in(user)
    visit question_path(question)

    within '.question' do
      click_on 'Edit question'
      attach_file "#{Rails.root}/spec/rails_helper.rb"
      click_on 'Edit the question'
    end
  end

  describe 'Authenticated user', js: true do
    scenario 'Author deletes attached files' do
      within '.question' do
        click_on '(Delete)'
        page.driver.browser.switch_to.alert.accept

        expect(page).to_not have_link 'rails_helper.rb'
        expect(page).to_not have_link '(Delete)'
      end
    end

    scenario 'not the author tries to delete attached files' do
      sign_out
      sign_in(other_user)
      visit question_path(question)

      within '.question' do
        expect(page).to_not have_link '(Delete)'
      end
      expect(page).to have_content question.body
    end
  end

  describe 'Unathenticated user', js: true do
    scenario 'tries to delete attached files' do
      sign_out
      visit question_path(question)

      within '.question' do
        expect(page).to_not have_link '(Delete)'
      end
      expect(page).to have_content question.body
    end
  end
end
