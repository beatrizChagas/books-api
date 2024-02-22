require 'rails_helper'

RSpec.describe 'Categories', type: :request do
  let!(:categories) { create_list(:category, 5) }
  let!(:category_id) { categories.first.id }

  describe 'GET /index' do
    before { get '/api/v1/categories' }

    it 'returns categories' do
      expect(response.parsed_body).not_to be_empty
      expect(response.parsed_body.size).to eq(5)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /create' do
    let(:valid_name) { { name: 'Test' } }

    context 'when the request is valid' do
      before { post '/api/v1/categories', params: valid_name }

      it 'creates a category' do
        expect(response.parsed_body['name']).to eq('Test')
      end

      it 'returns a status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/api/v1/categories', params: { name: '' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to include(
          'is too short (minimum is 3 characters)'
        )
      end
    end
  end

  describe 'DELETE /categories/:id' do
    before { delete "/api/v1/categories/#{category_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
