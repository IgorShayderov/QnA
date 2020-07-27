# frozen_string_literal: true

require 'rails_helper'

feature 'User can add comments', "
  In order to write my opinion about answers and questions
  As an authenticated User
  I'd like to be able to add comments
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'creates comment for question' do
      within '.question' do
        fill_in 'Your comment', with: 'Comment'
        click_on 'Add comment'
      end

      expect(page).to have_content 'Comment'
    end

    scenario 'creates comment for answer' do
      within '.answers' do
        fill_in 'Your comment', with: 'Comment'
        click_on 'Add comment'
      end

      expect(page).to have_content 'Comment'
    end

    scenario 'tries to create invalid comment' do
      within '.question' do
        click_on 'Add comment'
      end

      expect(page).to have_content "Body can't be blank"
    end
  end

  describe 'Unauthenticated user', js: true do
    scenario 'tries to create comment' do
      visit question_path(question)

      expect(page).to_not have_link 'Add comment'
    end
  end
end
