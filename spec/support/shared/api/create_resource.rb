shared_examples_for 'create resource' do
  context 'authorized' do
    let(:resource_class) { resource.class }
    let(:resource_name) { resource_class.name.underscore }

    context 'with valid params' do
      before do
        post api_path, params:
      { access_token: access_token.token, resource.class.name.underscore => resource_params },
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

      it 'creates resource' do
        expect do
          post api_path, params:
        { access_token: access_token.token, resource_name => resource_params },
                        headers: headers
        end.to change(resource_class, :count).by(1)
      end
    end

    context 'with invalid params' do
      before do
        post api_path, params:
      { access_token: access_token.token, resource_name => invalid_params },
                       headers: headers
      end

      it_behaves_like 'invalid params'

      it 'does not create resource' do
        expect { response }.to_not change(resource_class, :count)
      end
    end
  end
end
