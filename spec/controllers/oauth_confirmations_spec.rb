require 'rails_helper'

RSpec.describe OauthConfirmationsController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'POST #create' do
    let!(:email) { 'test@google.com' }

    context 'with valid attributes' do
      it 'saves a new user in the database' do
        expect { post :create, params: { email: email } }.to change(User, :count).by(1)
      end

      it 'render create view' do
        post :create, params: { email: email }

        expect(response).to render_template 'devise/mailer/confirmation_instructions'
      end
    end

    context 'with invalid attributes' do
      it "don't save new user" do
        expect { post :create, params: { email: 'invalid email' } }.to_not change(User, :count)
      end

      it 're-renders new' do
        post :create, params: { email: 'invalid email' }

        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #new' do
    it 'renders new view' do
      get :new

      expect(response).to render_template :new
    end
  end
end
