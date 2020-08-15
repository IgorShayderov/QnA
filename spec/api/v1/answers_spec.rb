require 'rails_helper'

describe 'Answers API', type: :request do
  let!(:question) { create(:question) }
  let!(:answers) { create_list(:answer, 3, question: question) }
  let!(:answer) { answers.first }
  let!(:links) { create_list(:link, 3, linkable: answer) }
  let!(:votes) { create_list(:vote, 3, votable: answer) }
  let!(:comments) { create_list(:comment, 3, commentable: answer) }

  let(:access_token) { create(:access_token) }
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
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
end
