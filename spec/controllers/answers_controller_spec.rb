require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, question: question, author: user) }
  before { login(user) }

  describe 'POST #create' do
    before do
      post :create, params: { answer: attributes_for(:answer), question_id: question }
    end

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show question view' do
        expect(response).to redirect_to assigns(:question)
      end

      it 'belongs to the user who has created it' do
        expect(assigns(:answer).user_id).to be user.id
      end
    end

    context 'with invalid attributes' do
      it 'doesn not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question } }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }
        
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'assigns the requsted answer to @answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }

        expect(assigns(:answer)).to eq answer
      end
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }
        answer.reload

        expect(answer.body).to eq 'new body'
      end
      it 'redirects to updated answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }

        expect(response).to redirect_to answer
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) } }
      let!(:answer_body) { answer.body }

      it 'does not change answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }
        answer.reload

        expect(answer.body).to eq answer_body
      end
      it 're-renders edit view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }
        
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, author: user) }
    let!(:other_user) { create(:user) }
    let!(:other_answer) { create(:answer, question: question, author: other_user )}

    context 'Author of element' do
      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer, question_id: question } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: answer, question_id: question }

        expect(response).to redirect_to question
      end
    end

    context 'User who is not author of an element' do
      it 'tries to delete question' do
        expect { delete :destroy, params: { id: other_answer, question_id: question } }.to_not change(Answer, :count)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: other_answer, question_id: question }

        expect(response).to redirect_to question_path(question)
      end
    end
  end
end
