require 'rails_helper'

RSpec.describe 'Songs API', type: :request do
  # initialize test data 
  let!(:artist) { create(:artist) }
  let!(:album) { create(:album, artist_id: artist.id) }
  let!(:songs) { create_list(:song, 10, artist_id: artist.id, album_id: album.id) }
  let(:song_id) { songs.first.id }

  # Test suite for GET /songs
  describe 'GET /songs' do
    # make HTTP get request before each example
    before { get "/artists/#{artist.id}/albums/#{album.id}/songs" }

    it 'returns songs' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /songs/:id
  describe 'GET /songs/:id' do
    before { get "/artists/#{artist.id}/albums/#{album.id}/songs/#{song_id}" }

    context 'when the song exists' do
      it 'returns the song' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(song_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the song does not exist' do
      let(:song_id) { 'invalid' }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Song/)
      end
    end
  end

  # Test suite for POST /songs
  describe 'POST /songs' do
    # valid payload
    let(:valid_attributes) { { name: 'I am Murloc', duration: 100 } }

    context 'when the request is valid' do
      before { post "/artists/#{artist.id}/albums/#{album.id}/songs", params: valid_attributes }

      it 'creates an song' do
        expect(json['name']).to eq('I am Murloc')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    describe 'when request is invalid' do
      before { post "/artists/#{artist.id}/albums/#{album.id}/songs", params: invalid_attributes }
      context 'when the name is missing' do
        let(:invalid_attributes) { { duration: 100 } }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          expect(response.body)
            .to match(/Validation failed: Name can't be blank/)
        end
      end

      context 'when the duration is missing' do
        before { post "/artists/#{artist.id}/albums/#{album.id}/songs", params: invalid_attributes }
        let(:invalid_attributes) { { name: 'I am Murloc' } }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          expect(response.body)
            .to match(/Validation failed: Duration can't be blank/)
        end
      end
    end
  end

  # Test suite for PUT /songs/:id
  describe 'PUT /songs/:id' do
    let(:valid_attributes) { { name: 'I am not Murloc', duration: 100 } }

    context 'when the song exists' do
      before { put "/artists/#{artist.id}/albums/#{album.id}/songs/#{song_id}", params: valid_attributes }

      it 'updates the song' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the song does not exists' do
      before { put "/artists/#{artist.id}/albums/#{album.id}/songs/invalid_id", params: valid_attributes }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  # Test suite for DELETE /songs/:id
  describe 'DELETE /songs/:id' do
    before { delete "/artists/#{artist.id}/albums/#{album.id}/songs/#{song_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end