# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let!(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  before { login(user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3, author: user) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end
    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'renders show view' do
      expect(response).to render_template :show
    end

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
  end

  describe 'GET #new' do
    before { get :new }

    it 'renders new view' do
      expect(response).to render_template :new
    end

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      before do
        post :create, params: { question: attributes_for(:question) }
      end

      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        expect(response).to redirect_to assigns(:question)
      end

      it 'belongs to the user who has created it' do
        expect(assigns(:question).user_id).to be user.id
      end
    end

    context 'with invalid attributes' do
      it 'doesn not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }

        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update', js: true do
    context 'with valid attributes' do
      it 'assigns the requsted question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(assigns(:question)).to eq question
      end
      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js }
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end
      it 'renders update template' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid), format: :js } }
      let!(:question_before_update) { question }

      it 'does not change question' do
        patch :update, params: { id: question, question: attributes_for(:question, :invalid), format: :js }
        question.reload

        expect(question.title).to eq question_before_update.title
        expect(question.body).to eq question_before_update.body
      end
      it 'renders update template' do
        patch :update, params: { id: question, question: attributes_for(:question, :invalid), format: :js }

        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, author: user) }
    let!(:other_user) { create(:user) }
    let!(:other_question) { create(:question, author: other_user) }

    context 'Author of element' do
      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }

        expect(response).to redirect_to questions_path
      end
    end

    context 'User who is not author of an element' do
      it 'tries to delete question' do
        expect { delete :destroy, params: { id: other_question } }.to_not change(Question, :count)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: other_question }

        expect(response).to redirect_to root_url
      end
    end
  end
end
