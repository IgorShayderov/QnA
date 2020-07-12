# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to the questions', "
  In order to provide additional info to my question
  As an author of the question
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:google_url) { 'https://www.google.com' }

  scenario 'User adds link when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    click_link 'Add link'
    fill_in 'Link name:', with: 'Google'
    fill_in 'Link url:', with: google_url
    click_on 'Ask'

    expect(page).to have_link 'Google', href: google_url
  end

  scenario 'User deletes link', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    click_link 'Add link'
    fill_in 'Link name:', with: 'Google'
    fill_in 'Link url:', with: google_url
    click_on 'Ask'

    within '.question' do
      click_link 'Edit question'
      page.check({ class: 'destroy_link' })
      click_on 'Edit the question'
      page.driver.browser.navigate.refresh

      expect(page).to_not have_link 'Google', href: google_url
    end
  end
end
