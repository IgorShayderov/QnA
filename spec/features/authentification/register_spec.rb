# frozen_string_literal: true

require 'rails_helper'

feature 'User can register', "
  In order to sign in
  As an user
  I'd like to be able register
" do
  given(:password) { '12345678' }

  scenario 'User trying to register' do
    visit new_user_registration_path

    fill_in 'Email', with: 'sample@test.com'
    fill_in 'Password', with: password
    fill_in 'Password confirmation', with: password
    click_on 'Sign up'

    expect(page).to have_content('Welcome! You have signed up successfully')
  end
end
