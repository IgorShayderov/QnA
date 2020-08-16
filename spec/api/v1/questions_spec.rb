# frozen_string_literal: true

require 'rails_helper'

describe 'Questions API', type: :request do
  let!(:question) { create(:question, user_id: access_token.resource_owner_id) }
  let!(:answers) { create_list(:answer, 3, question: question) }
  let!(:links) { create_list(:link, 3, linkable: question) }
  let!(:votes) { create_list(:vote, 3, votable: question) }
  let!(:comments) { create_list(:comment, 3, commentable: question) }

  let(:access_token) { create(:access_token) }
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  before { 2.times { question.files.attach(create_file_blob) } }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:questions) { create_list(:question, 2) }
      let(:question_response) { json['questions'].first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 3
      end

      it_behaves_like 'test question attributes'
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:question_response) { json['question'] }

      before { get api_path, params: { id: question.id, access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it_behaves_like 'test question attributes'
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      context 'valid params' do
        let(:question_response) { json['question'] }
        let(:question_params) { { title: 'Question title', body: 'question body' } }

        before do
          post api_path, params:
        { access_token: access_token.token, question: question_params },
                         headers: headers
        end

        it 'returns 200 status' do
          expect(response).to be_successful
        end

        it 'returned object contains transmitted params' do
          question_params.each do |param_key, param_value|
            expect(question_response[param_key.to_s]).to eq param_value
          end
        end

        it 'creates question' do
          expect { post api_path, params:
          { access_token: access_token.token, question: question_params },
                           headers: headers }.to change(Question, :count).by(1)
        end
      end

      context 'with invalid params' do
        let(:invalid_params) { { title: '' } }

        before do
          post api_path, params:
        { access_token: access_token.token, question: invalid_params },
                         headers: headers
        end

        it_behaves_like 'invalid params'

        it 'does not create question' do
          expect { response }.to_not change(Question, :count)
        end
      end
    end
  end

  describe 'PUT /api/v1/questions/:id' do
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :put }
    end

    context 'authorized' do
      context 'valid params' do
        let(:question_params) { { title: 'Question title', body: 'question body' } }
        let(:question_response) { json['question'] }

        before do
          put api_path, params:
        { access_token: access_token.token, question: question_params },
                        headers: headers
        end

        it 'returns 200 status' do
          expect(response).to be_successful
        end

        it 'returned object contains transmitted params' do
          question_params.each do |param_key, param_value|
            expect(question_response[param_key.to_s]).to eq param_value
          end
        end
      end

      context 'invalid params' do
        let(:invalid_params) { { title: '' } }
        let(:question_title) { question.title }

        before do
          put api_path, params:
        { access_token: access_token.token, question: invalid_params },
                        headers: headers
        end

        it_behaves_like 'invalid params'

        it 'does not change question title after request' do
          expect(question.title).to be question_title
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let!(:question_to_delete) { create(:question, user_id: access_token.resource_owner_id) }
    let(:api_path) { "/api/v1/questions/#{question_to_delete.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      it 'returns 200 status' do
        delete api_path, params: { access_token: access_token.token }, headers: headers

        expect(response).to be_successful
      end

      it 'deletes question' do
        expect { delete api_path, params: { access_token: access_token.token }, headers: headers }.to change(Question, :count).by(-1)
      end
    end
  end
end
