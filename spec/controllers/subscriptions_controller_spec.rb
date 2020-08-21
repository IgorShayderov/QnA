require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let!(:user) { create(:user) }
  before { login(user) }

  describe 'POST #create' do
    let!(:question) { create(:question) }

    it 'creates new subscription for question' do
      expect { post :create, params: { question_id: question.id } }.to change(Subscription, :count).by(1)
    end

    it 'redirects to question' do
      post :create, params: { question_id: question.id }

      expect(response).to redirect_to question
    end
  end

  describe 'DELETE #destroy' do

  end
end
