# frozen_string_literal: true

require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
  end
  let!(:me) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json[attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not returns private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    let(:api_path) { '/api/v1/profiles' }
    let!(:profiles) { create_list(:user, 3) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields for each profile' do
        profiles.each_with_index do |profile, index|
          %w[id email admin created_at updated_at].each do |attr|
            expect(json[index][attr]).to eq profile.send(attr).as_json
          end
        end
      end

      it 'does not returns private fields for each profile' do
        profiles.each_with_index do |_profile, index|
          %w[password encrypted_password].each do |attr|
            expect(json[index]).to_not have_key(attr)
          end
        end
      end

      it 'does not return me' do
        profiles.each do |profile|
          expect(profile['id']).to_not eq me.id
        end
      end
    end
  end
end
