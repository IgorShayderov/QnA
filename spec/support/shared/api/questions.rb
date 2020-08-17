# frozen_string_literal: true

shared_examples_for 'test question attributes' do
  it 'returns all public fields' do
    %w[id title body created_at updated_at].each do |attr|
      expect(question_response[attr]).to eq question.send(attr).as_json
    end
  end

  it 'contains user object' do
    expect(question_response['author']['id']).to eq question.author.id
  end

  it 'contains short title' do
    expect(question_response['short_title']).to eq question.title.truncate(7)
  end

  describe 'answers' do
    let(:answer) { answers.first }
    let(:answer_response) { question_response['answers'].first }

    it 'returns list of questions' do
      expect(question_response['answers'].size).to eq 3
    end

    it 'returns all public fields' do
      %w[id body created_at updated_at].each do |attr|
        expect(answer_response[attr]).to eq answer.send(attr).as_json
      end
    end
  end

  it_behaves_like 'resource links' do
    let(:resource_response) { question_response }
  end

  it_behaves_like 'resource votes' do
    let(:resource_response) { question_response }
  end

  it_behaves_like 'resource comments' do
    let(:resource_response) { question_response }
  end

  it_behaves_like 'resource attachments' do
    let(:resource) { question }
    let(:resource_response) { question_response }
  end
end
