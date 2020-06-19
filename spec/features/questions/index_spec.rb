require 'rails_helper'

feature 'User can view questions list', %q{
  In order to choose certain question
  As an User
  I'd like to be able to see questions list
} do

  given(:user) { create(:user) }

  scenario 'Anyone can view questions list' do
    FactoryBot.create_list(:question, 3, author: user)
    visit root_path

    expect(page).to have_content('QuestionTitle', count: 3)
  end

end
