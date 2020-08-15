require 'rails_helper'

describe 'Questions API', type: :request do
  let!(:question) { create(:question) }
  let!(:answers) { create_list(:answer, 3, question: question) }
  let!(:links) { create_list(:link, 3, linkable: question) }
  let!(:votes) { create_list(:vote, 3, votable: question) }
  let!(:comments) { create_list(:comment, 3, commentable: question) }

  let(:access_token) { create(:access_token) }
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
  end

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
end
