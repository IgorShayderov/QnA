# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign out', "
  As an athenticated user
  I'd like to be able to sign out
" do
  given(:user) { create(:user) }

  background { sign_in(user) }

  scenario 'Authenticated user logging out' do
    click_link 'Sign out'

    expect(page).to have_content 'Signed out successfully'
  end
end
