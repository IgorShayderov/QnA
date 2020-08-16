# frozen_string_literal: true

shared_examples_for 'test answer attributes' do
  it 'returns all public fields' do
    %w[id body created_at updated_at].each do |attr|
      expect(answer_response[attr]).to eq answer.send(attr).as_json
    end
  end

  it 'contains user object' do
    expect(answer_response['author']['id']).to eq answer.author.id
  end

  it_behaves_like 'resource links' do
    let(:resource_response) { answer_response }
  end

  it_behaves_like 'resource votes' do
    let(:resource_response) { answer_response }
  end

  it_behaves_like 'resource comments' do
    let(:resource_response) { answer_response }
  end

  it_behaves_like 'resource attachments' do
    let(:resource) { answer }
    let(:resource_response) { answer_response }
  end
end
