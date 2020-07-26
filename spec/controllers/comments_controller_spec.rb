# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question) }

  describe 'POST #create' do
    context 'Authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves comment to database' do
          expect { post :create, params: { question_id: question.id, comment: attributes_for(:comment), format: :js } }
            .to change(Comment, :count).by(1)
        end

        it 'renders create template' do
          post :create, params: { question_id: question.id, comment: attributes_for(:comment), format: :js }
          expect(response).to render_template :create
        end

        it 'broadcasts ne comment' do
          expect { post :create, params: { question_id: question.id, comment: attributes_for(:comment), format: :js } }
            .to have_broadcasted_to("questions/#{question.id}/comments")
        end
      end

      context 'with invalid attributes' do
        it 'does not saves comment to database' do
          expect { post :create, params: { question_id: question.id, comment: attributes_for(:comment, :invalid), format: :js } }
            .to_not change(Comment, :count)
        end
      end
    end

    context 'Unauthenticated user' do
      it 'does not saves comment to database' do
        expect { post :create, params: { question_id: question.id, comment: attributes_for(:comment), format: :js } }
          .to_not change(Comment, :count)
      end
    end
  end
end
