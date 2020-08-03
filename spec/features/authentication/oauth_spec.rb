# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign in through oauth providers', "
  In order to ask question
  As an unauthenticated user
  I'd link to be able to sign in through oauth providers
" do
  given!(:user) { create(:user) }
  given!(:test_email) { 'test@google.com' }

  describe 'Github authorization' do
    scenario 'registred user authenticates' do
      visit new_user_session_path
      mock_auth_hash(:github, email: user.email)

      click_on 'Sign in with GitHub'

      expect(page).to have_content 'Successfully authenticated from Github account'
      expect(page).to have_link 'Sign out'
    end

    scenario 'unregistred user authenticates' do
      visit new_user_session_path
      mock_auth_hash(:github)

      click_on 'Sign in with GitHub'

      expect(page).to have_content 'Successfully authenticated from Github account'
      expect(page).to have_link 'Sign out'
    end

    scenario 'authenticate without email' do
      visit new_user_session_path
      mock_auth_hash(:github, email: '')

      click_on 'Sign in with GitHub'
      fill_in 'Email', with: test_email
      click_on 'Send email'

      expect(page).to have_content "Email confirmation has been send to #{test_email}"

      open_email(test_email)
      current_email.click_link 'Confirm my account'

      expect(page).to have_content 'Your email address has been successfully confirmed'
    end
  end
end
