require 'rails_helper'

RSpec.describe 'Books', type: :request do
  let!(:books) { create_list(:book, 10) }
  let(:book_id) { books.first.id }

  describe 'GET /books' do
    before { get '/api/v1/books' }

    it 'returns books' do
      expect(response.body).not_to be_empty
      expect(response.parsed_body.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /books/:id' do
    before { get "/api/v1/books/#{book_id}" }

    context 'when book exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the book item' do
        expect(response.parsed_body['id']).to eq(book_id)
      end
    end

    context 'when book does not exist' do
      let(:book_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.parsed_body['error']).to include(
          "Couldn't find Book with 'id'=0"
        )
      end
    end
  end

  describe 'POST /books/:id' do
    let!(:history) { create(:category) }
    let(:valid_attributes) do
      { title: 'some-book', author: 'some-author', category_id: history.id }
    end

    context 'when request attributes are valid' do
      before { post '/api/v1/books', params: valid_attributes }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      before { post '/api/v1/books', params: {} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns the failure messages' do
        expect(response.parsed_body['author']).to include("can't be blank")
        expect(response.parsed_body['category']).to include('must exist')
        expect(response.parsed_body['title']).to include("can't be blank")
      end
    end
  end

  describe 'PUT /books/:id' do
    let(:valid_attributes) { { title: 'some-title' } }
    before { put "/api/v1/books/#{book_id}", params: valid_attributes }

    context 'when book exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates the book' do
        update_item = Book.find(book_id)

        expect(update_item.title).to match(/some-title/)
      end
    end

    context 'when the book does not exists' do
      let(:book_id) { 0 }

      it 'returns a status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.parsed_body['error']).to include(
          "Couldn't find Book with 'id'=0"
        )
      end
    end
  end

  describe 'DELETE /books/:id' do
    before { delete "/api/v1/books/#{book_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
