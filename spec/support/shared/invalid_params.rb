shared_examples_for 'invalid params' do
  it 'returns 400 status' do
    expect(response).to_not be_successful
  end

  it 'returns list of errors' do
    expect(json['errors'].length).to be > 0
  end
end
