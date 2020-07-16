# frozen_string_literal: true

require 'rails_helper'

feature 'User can vote for answer', "
  In order to highlight useful answers
  As an authenticated User
  I'd like to be able to vote for liked answers
" do
#  - Аутентифицированный пользователь может голосовать за понравившийся вопрос/ответ
#  - Пользователь не может голосовать за свой вопрос/ответ
#  - Пользователь может проголосовать "за" или "против" конкретного вопроса/ответа только один раз (нельзя голосовать 2 раза подряд "за" или "против")
#  - Пользователь может отменить свое решение и после этого переголосовать.
#  - У вопроса/ответа должен выводиться результирующий рейтинг (разница между голосами "за" и "против")

  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: other_user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    # can vote for liked answer
    it 'votes for answer' do
      # vote for answer
      within '.answers' do
        click_on 'Vote'
      end

      expect(find('.answer-votes-total').text).to be(1)
    end
  end

  describe 'Unauthenticated user' do
    
  end

end
