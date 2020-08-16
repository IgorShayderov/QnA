shared_examples_for 'update resource in controller' do
  context 'with valid attributes' do
    it 'assigns the requsted resource to @resource' do
      patch :update, params: { id: resource, resource_name => attributes_for(resource_name.to_sym), format: :js }

      expect(assigns(resource_name.to_sym)).to eq resource
    end

    it 'changes resource attributes' do
      patch :update, params: { id: resource, resource_name => resource_params }, format: :js
      resource.reload

      resource_attributes.each do |attr|
        expect(resource[attr]).to eq resource_params[attr]
      end
    end

    it 'renders update template' do
      patch :update, params: { id: resource, resource_name => attributes_for(resource_name.to_sym), format: :js }

      expect(response).to render_template :update
    end
  end

  context 'with invalid attributes' do
    before { patch :update, params: { id: resource, resource_name => attributes_for(resource_name.to_sym, :invalid), format: :js } }
    let!(:saved_attributes) { resource_attributes.map { |attribute| resource[attribute] } }

    it 'does not change answer' do
      patch :update, params: { id: resource, resource_name => attributes_for(resource_name.to_sym, :invalid), format: :js }
      resource.reload

      resource_attributes.each_with_index do |attr, index|
        expect(resource[attr]).to eq saved_attributes[index]
      end
    end
    it 'renders update template' do
      patch :update, params: { id: resource, resource_name => attributes_for(resource_name.to_sym, :invalid), format: :js }

      expect(response).to render_template :update
    end
  end
end
