require 'sphinx_helper'

feature 'User can search records through search bar', "
  In order to search certain text or part of text
  As an user
  I'd like to be able to use search
" do
let!(:question) { create(:question, body: 'extraterrestial') }

  describe 'search', sphinx: true, js: true do
    it 'existing record' do
      visit root_path

      fill_in 'context', with: 'extraterresial'
      click_button 'Search'
  
      expect(page).to have_content 'Question'
      expect(page).to have_content 'extraterrestial'
    end
  
    it 'non-existing record' do
      visit root_path
  
      fill_in 'context', with: 'sophisticated'
      click_button 'Search'
  
      expect(page).to_not have_content 'sophisticated'
    end
  
  end
end
