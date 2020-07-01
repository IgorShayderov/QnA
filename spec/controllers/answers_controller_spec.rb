# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let!(:user) { create(:user) }
  let!(:question) { create(:question, author: user) }
  let!(:answer) { create(:answer, question: question, author: user) }
  let!(:other_user) { create(:user) }
  let!(:other_answer) { create(:answer, question: question, author: other_user) }
  before { login(user) }

  describe 'POST #create' do
    before do
      post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
    end

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js } }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show question view' do
        expect(response).to render_template :create
      end

      it 'belongs to the user who has created it' do
        expect(assigns(:answer).user_id).to be user.id
      end
    end

    context 'with invalid attributes' do
      it 'doesn not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question, format: :js } }.to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question, format: :js }

        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'assigns the requsted answer to @answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }

        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload

        expect(answer.body).to eq 'new body'
      end

      it 'renders update template' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }

        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), format: :js } }
      let!(:answer_body) { answer.body }

      it 'does not change answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), format: :js }
        answer.reload

        expect(answer.body).to eq answer_body
      end
      it 'renders update template' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), format: :js }

        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Author of element' do
      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'renders destroy template' do
        delete :destroy, params: { id: answer }, format: :js

        expect(response).to render_template :destroy
      end
    end

    context 'User who is not author of an element' do
      it 'tries to delete question' do
        expect { delete :destroy, params: { id: other_answer }, format: :js }.to_not change(Answer, :count)
      end

      it 'renders destroy template' do
        delete :destroy, params: { id: other_answer }, format: :js

        expect(response).to render_template :destroy
      end
    end
  end

  describe 'PATCH #best' do
    context 'Author of answer' do
      it 'chooses best answer' do
        patch :best, params: { id: answer }, format: :js
        answer.reload

        expect(answer).to be_best
      end
    end

    context 'not the Author of answer' do
      it 'tries to choose best answer' do
        patch :best, params: { id: other_answer }, format: :js
        answer.reload

        expect(answer).to_not be_best
      end
    end
  end

  describe 'DELETE #delete_file' do
    
  end
end
