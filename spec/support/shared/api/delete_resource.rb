shared_examples_for 'delete resource' do
  context 'authorized' do
    it 'returns 200 status' do
      delete api_path, params: { access_token: access_token.token }, headers: headers

      expect(response).to be_successful
    end

    it 'deletes question' do
      expect { delete api_path, params: { access_token: access_token.token }, headers: headers }.to change(resource.class, :count).by(-1)
    end
  end

end
