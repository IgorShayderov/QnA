require 'rails_helper'

feature 'User can view question and related answers', %q{
  In order to choose certain question
  As an User
  I'd like to be able to see the question and related answers
} do

  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'Anyone can view certain question' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content answer.body
  end

end