require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question) }

  before { login(user) }

  describe 'POST #create' do

    it 'creates new subscription for question' do
      expect { post :create, params: { question_id: question.id } }.to change(Subscription, :count).by(1)
    end

    it 'redirects to question' do
      post :create, params: { question_id: question.id }

      expect(response).to redirect_to question
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscription) { create(:subscription, question: question) }

    it 'deletes subscription' do
      expect { delete :destroy, params: { id: subscription.id } }.to change(Subscription, :count).by(-1)
    end

    it 'redirects to question' do
      delete :destroy, params: { id: subscription.id }

      expect(response).to redirect_to question
    end
  end
end
