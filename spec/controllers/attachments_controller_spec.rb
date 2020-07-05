# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:question) { create(:question, author: user) }
  let!(:other_question) { create(:question, author: other_user) }

  describe 'DELETE #destroy' do
    before do
      question.files.attach(create_file_blob)
      other_question.files.attach(create_file_blob)
    end

    context 'Authenticated user' do
      before { sign_in(user) }

      context 'author of question' do
        it 'deletes file from databse' do
          expect { delete :destroy, params: { id: question.files.first.id }, format: :js }.to change(question.files, :count).by(-1)
        end

        it 'renders destroy template' do
          delete :destroy, params: { id: question.files.first, format: :js }

          expect(response).to render_template :destroy
        end
      end

      context 'not author of question' do
        it 'tries to delete the file' do
          expect { delete :destroy, params: { id: other_question.files.first.id }, format: :js }.to_not change(other_question.files, :count)
        end
      end
    end

    context 'Unauthenticated user' do
      it 'tries to delete the file' do
        expect { delete :destroy, params: { id: question.files.first.id }, format: :js }.to_not change(other_question.files, :count)
      end
    end
  end
end
