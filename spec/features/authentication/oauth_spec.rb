# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign in through oauth providers', "
  In order to ask question
  As an unauthenticated user
  I'd link to be able to sign in through oauth providers
" do
  given!(:user) { create(:user) }

  before do
    Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]
    Rails.application.env_config["omniauth.auth"] = mock_auth(user)
  end

  describe 'Github' do
    context 'registred user' do
      given!(:authorization) { create(:authorization, user: user) }

      scenario 'had authentication' do
        visit new_user_session_path

        click_link 'Sign in with GitHub'

        expect(page).to have_content 'Successfully authenticated from Github account'
        expect(page).to have_link 'Sign out'
      end

      scenario 'had no authentication' do
        # confirm and successful authentication
      end
    end

    context 'Unregistred user' do
      scenario 'authenticate with email'
      scenario 'authenticate without email'
    end
  end
end
