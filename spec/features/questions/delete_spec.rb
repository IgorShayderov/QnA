require 'rails_helper'

feature 'Author can delete his begotten questions', %q{
  In order to delete my begotten questions
  As an authenticated User
  I'd like to be able to delete questions
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  describe 'User tries to delete' do
    background do
      FactoryBot.create_list(:question, 3, author: user)
    end

    scenario 'his begotten question' do
      sign_in(user)
      visit question_path(question)

      click_on 'Delete question'

      expect(page).to_not have_content question.title
      expect(page).to have_content('QuestionTitle', count: 3)
    end

    scenario 'foreign question' do
      sign_in(other_user)
      visit question_path(question)

      expect(page).to_not have_content 'Delete question'
    end

  end
end
