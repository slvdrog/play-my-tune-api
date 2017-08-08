require 'rails_helper'

RSpec.describe 'Albums API', type: :request do
  # initialize test data 
  let!(:artist) { create(:artist) }
  let!(:albums) { create_list(:album, 7, artist_id: artist.id) }
  let(:album_id) { albums.first.id }

  # Test suite for GET /albums
  describe 'GET /albums' do
    # make HTTP get request before each example
    before { get '/albums' }

    it 'returns albums' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(7)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /albums/:id
  describe 'GET /albums/:id' do
    before { get "/albums/#{album_id}" }

    context 'when the album exists' do
      it 'returns the album' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(album_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the album does not exist' do
      let(:album_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Album/)
      end
    end
  end

  # Test suite for POST /albums
  describe 'POST /albums' do
    # valid payload
    let(:valid_attributes) { { name: 'Elite Tauren Chieftain Disc 1', art: 'www.something.com/album.jpeg', artist_id: artist.id } }

    context 'when the request is valid' do
      before { post '/albums', params: valid_attributes }

      it 'creates an album' do
        expect(json['name']).to eq('Elite Tauren Chieftain Disc 1')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    describe 'when request is invalid' do
      context 'when the artist_id is missing' do
        before { post '/albums', params: { name: 'Elite Tauren Chieftain Disc 1', art: 'something.jpeg' } }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          expect(response.body)
            .to match(/Validation failed: Artist must exist/)
        end
      end

      context 'when the name is missing' do
        before { post '/albums', params: { artist_id: artist.id, art: 'something.jpeg' } }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          expect(response.body)
            .to match(/Validation failed: Name can't be blank/)
        end
      end
    end
  end

  # Test suite for PUT /albums/:id
  describe 'PUT /albums/:id' do
    let(:valid_attributes) { { name: 'New ETC' } }

    context 'when the album exists' do
      before { put "/albums/#{album_id}", params: valid_attributes }

      it 'updates the album' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the album does not exists' do
      before { put "/albums/invalid", params: valid_attributes }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  # Test suite for DELETE /albums/:id
  describe 'DELETE /albums/:id' do
    before { delete "/albums/#{album_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end