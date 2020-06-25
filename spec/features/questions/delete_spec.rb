# frozen_string_literal: true

require 'rails_helper'

feature 'Author can delete his begotten questions', "
  In order to delete my begotten questions
  As an authenticated User
  I'd like to be able to delete questions
" do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  describe 'Trying to delete question' do
    context 'as authenticated User' do
      it 'his begotten question' do
        sign_in(user)
        visit question_path(question)

        click_on 'Delete question'

        expect(page).to_not have_content('QuestionTitle')
      end

      it 'foreign question' do
        sign_in(other_user)
        visit question_path(question)

        expect(page).to_not have_content 'Delete question'
      end
    end

    context 'as unauthenticated User' do
      it 'whatever answer' do
        visit question_path(question)

        expect(page).to_not have_content 'Delete question'
      end
    end
  end
end
