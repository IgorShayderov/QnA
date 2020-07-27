# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to the answers', "
  In order to provide additional info to my answer
  As an author of the answer
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given(:google_url) { 'https://www.google.com' }

  scenario 'User adds link when give answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'New answer', with: 'My answer'
    click_link 'Add link'
    fill_in 'Link name:', with: 'Google'
    fill_in 'Link url:', with: google_url
    click_on 'Answer the question'
    page.driver.browser.navigate.refresh

    within '.answers' do
      expect(page).to have_link 'Google', href: google_url
    end
  end

  scenario 'User deletes link', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'New answer', with: 'My answer'
    click_link 'Add link'
    fill_in 'Link name:', with: 'Google'
    fill_in 'Link url:', with: google_url
    click_on 'Answer the question'
    page.driver.browser.navigate.refresh

    within '.answers' do
      click_on 'Edit answer'
      page.check({ class: 'destroy_link' })
      click_on 'Edit the answer'
      page.driver.browser.navigate.refresh

      expect(page).to_not have_link 'Google', href: google_url
    end
  end
end
