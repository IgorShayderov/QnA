shared_examples_for 'update resource' do
  context 'authorized' do
    let(:resource_name) { resource.class.name.underscore }

    context 'valid params' do
      before do
        put api_path, params:
      { access_token: access_token.token, resource_name => resource_params },
                      headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returned object contains transmitted params' do
        resource_params.each do |param_key, param_value|
          expect(resource_response[param_key.to_s]).to eq param_value
        end
      end
    end

    context 'invalid params' do
      before do
        put api_path, params:
      { access_token: access_token.token, resource_name => invalid_params },
                      headers: headers
      end

      it_behaves_like 'invalid params'

      it 'does not change question title after request' do
        expect(resource[param_for_updating]).to be saved_attribute
      end
    end
  end

end
