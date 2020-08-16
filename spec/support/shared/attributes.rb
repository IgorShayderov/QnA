# frozen_string_literal: true

shared_examples_for 'resource comments' do
  let(:comment) { comments.first }
  let(:comment_response) { resource_response['comments'].last }

  it 'returns list of comments' do
    expect(resource_response['comments'].size).to eq comments.size
  end

  it 'returns all public fields' do
    %w[id body commentable_type commentable_id user_id created_at updated_at].each do |attr|
      expect(comment_response[attr]).to eq comment.send(attr).as_json
    end
  end
end

shared_examples_for 'resource votes' do
  let(:vote) { votes.first }
  let(:vote_response) { resource_response['votes'].last }

  it 'returns list of votes' do
    expect(resource_response['votes'].size).to eq votes.size
  end

  it 'returns all public fields' do
    %w[id value votable_type votable_id user_id created_at updated_at].each do |attr|
      expect(vote_response[attr]).to eq vote.send(attr).as_json
    end
  end
end

shared_examples_for 'resource links' do
  let(:link) { links.first }
  let(:link_response) { resource_response['links'].last }

  it 'returns list of links' do
    expect(resource_response['links'].size).to eq links.size
  end

  it 'returns all public fields' do
    %w[id name url linkable_type linkable_id created_at updated_at].each do |attr|
      expect(link_response[attr]).to eq link.send(attr).as_json
    end
  end
end

shared_examples_for 'resource attachments' do
  let(:file) { resource.files.first }
  let(:file_response) { resource_response['files'].first }

  it 'returns list of files' do
    expect(resource_response['files'].size).to eq resource.files.size
  end

  it 'returns all public fields' do
    expect(file_response['id']).to eq file.id
    expect(file_response['filename']).to eq file.filename.to_s
    expect(file_response['url']).to eq rails_blob_path(file, only_path: true)
  end
end
