# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to the answers', "
  In order to provide additional info to my answer
  As an author of the answer
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given(:gist_url) { 'https://gist.github.com/IgorShayderov/95499d72cd95023b48532dae7f547d9e' }

  scenario 'User adds link when give answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'New answer', with: 'My answer'
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url
    click_on 'Answer the question'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end

  scenario 'User deletes link', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'New answer', with: 'My answer'
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url
    click_on 'Answer the question'

    within '.answers' do
      click_on 'Edit answer'
      page.check({ class: 'destroy_link' })
      click_on 'Edit the answer'
      # page.driver.browser.navigate.refresh

      expect(page).to_not have_link 'My gist', href: gist_url
    end
  end
end
