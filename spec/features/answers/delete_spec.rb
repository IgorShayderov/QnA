require 'rails_helper'

feature 'Author can delete his begotten answers', %q{
  In order to delete my begotten answers
  As an authenticated User
  I'd like to be able to delete my answers
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }

  describe 'Trying to delete answer' do
    context 'as authenticated User' do
      it 'his begotten answer' do
        sign_in(user)
        visit question_path(question)

        click_on 'Delete answer'

        expect(page).to_not have_content answer.body
      end

      it 'foreign answer' do
        sign_in(other_user)
        visit question_path(question)

        expect(page).to_not have_link 'Delete answer'
      end
    end

    context 'as unauthenticated User' do
      it 'whatever answer' do
        visit question_path(question)

        expect(page).to_not have_link 'Delete answer'
      end
    end
  end
end