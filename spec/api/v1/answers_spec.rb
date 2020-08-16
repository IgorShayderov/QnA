# frozen_string_literal: true

require 'rails_helper'

describe 'Answers API', type: :request do
  let!(:question) { create(:question, user_id: access_token.resource_owner_id) }
  let!(:answers) { create_list(:answer, 3, question: question, user_id: access_token.resource_owner_id) }
  let!(:answer) { answers.first }
  let!(:links) { create_list(:link, 3, linkable: answer) }
  let!(:votes) { create_list(:vote, 3, votable: answer) }
  let!(:comments) { create_list(:comment, 3, commentable: answer) }

  let(:access_token) { create(:access_token) }
  let(:headers) do
    { 'ACCEPT' => 'application/json' }
  end

  before { 2.times { answer.files.attach(create_file_blob) } }

  describe 'GET /api/v1/questions/:question_id/answers' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:answer_response) { json['answers'].first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq answers.size
      end

      it_behaves_like 'test answer attributes'
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:answer_response) { json['answer'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it_behaves_like 'test answer attributes'
    end
  end

  describe 'POST /api/v1/questions/:id/answers' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    it_behaves_like 'create resource' do
      let(:resource_params) { { body: 'answer body' } }
      let(:resource_response) { json['answer'] }
      let(:resource) { answer }
      let(:invalid_params) { { body: '' } }
    end
  end

  describe 'PUT /api/v1/answers/:id' do
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :put }
    end

    it_behaves_like 'update resource' do
      let(:resource_params) { { body: 'answer body' } }
      let(:resource_response) { json['answer'] }
      let(:resource) { answer }
      let(:saved_attribute) { answer.body }
      let(:invalid_params) { { body: '' } }
      let(:param_for_updating) { :body }
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let!(:answer_to_delete) { create(:answer, user_id: access_token.resource_owner_id) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    it_behaves_like 'delete resource' do
      let(:resource) { answer }
    end
  end
end
