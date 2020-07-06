# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to the questions', "
  In order to provide additional info to my question
  As an author of the question
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/IgorShayderov/95499d72cd95023b48532dae7f547d9e' }

  scenario 'User adds link when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url
    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
  end
end
