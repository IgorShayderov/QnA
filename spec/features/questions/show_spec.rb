require 'rails_helper'

feature 'User can view question and related answers', %q{
  In order to choose certain question
  As an User
  I'd like to be able to see the question and related answers
} do

  given(:user) { create(:user) }
  given!(:answer) { create(:answer, question: question, author: user) }
  given!(:question) { create(:question, author: user) }

  scenario 'Anyone can view certain question' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content answer.body
  end

end