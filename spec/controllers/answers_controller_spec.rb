require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'GET #show' do
    it 'renders show view' do
      get :show, params: { id: answer }
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    it 'renders new view' do
      get :new, params: { question_id: question }
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    it 'renders edit view' do
      get :edit, params: { id: answer }
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show question view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }

        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'doesn not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question } }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }
        
        expect(response).to render_template :new
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

      it 'does not change answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }
        answer.reload

        expect(question.body).to eq 'MyText'
      end
      it 're-renders edit view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }
        
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question) }

    it 'deletes the answer' do
      expect { delete :destroy, params: { id: answer, question_id: question } }.to change(Answer, :count).by(-1)
    end

    it 'redirects to index' do
      delete :destroy, params: { id: answer, question_id: question }

      expect(response).to redirect_to question
    end
  end
end
