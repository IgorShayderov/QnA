# frozen_string_literal: true

require 'sphinx_helper'

RSpec.describe SearchesController, type: :controller do


  describe 'GET #index' do
    before { get :index, params: { option: 'question', context: 'text' }}

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end
