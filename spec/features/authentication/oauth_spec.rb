# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign in through oauth providers', "
  In order to ask question
  As an unauthenticated user
  I'd link to be able to sign in through oauth providers
" do
  given!(:user) { create(:user) }
  given(:uid) { '12345' }

  describe 'Github' do
    context 'Registred user' do
      background { mock_auth_hash(:github, email: user.email, uid: uid) }

      scenario 'tries to sign in for the first time' do
        visit new_user_session_path
        click_link 'Sign in with GitHub'

        expect(page).to have_content('Successfully authenticated from Github account')
        expect(page).to have_link 'Sign out'
      end
    end

    context 'Unregistred user'
  end
end

