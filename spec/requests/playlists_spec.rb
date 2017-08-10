require 'rails_helper'

RSpec.describe 'Playlists API', type: :request do
  # initialize test data 
  let!(:playlists) { create_list(:playlist, 7) }
  let(:playlist_id) { playlists.first.id }
  let!(:artist) { create(:artist) }
  let!(:album) { create(:album, artist_id: artist.id) }
  let(:song) { create(:song, artist: artist, album: album) }

  # Test suite for GET /playlists
  describe 'GET /playlists' do
    # make HTTP get request before each example
    before { get '/playlists' }

    it 'returns playlists' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(7)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /playlists/:id
  describe 'GET /playlists/:id' do
    before { get "/playlists/#{playlist_id}" }

    context 'when the record exists' do
      it 'returns the artist' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(playlist_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:playlist_id) { 'invalid' }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Playlist/)
      end
    end
  end

  # Test suite for POST /playlists
  describe 'POST /playlists' do
    # valid payload
    let(:valid_attributes) { { name: 'Those Eighties hits' } }

    context 'when the request is valid' do
      before { post '/playlists', params: valid_attributes }

      it 'creates a artist' do
        expect(json['name']).to eq('Those Eighties hits')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/playlists', params: { } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Name can't be blank/)
      end
    end
  end

  # Test suite for PUT /playlists/:id
  describe 'PUT /playlists/:id' do
    let(:valid_attributes) { { name: 'Those Nineties hits' } }

    context 'when the record exists' do
      before { put "/playlists/#{playlist_id}", params: valid_attributes }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  # Test suite for DELETE /playlists/:id
  describe 'DELETE /playlists/:id' do
    before { delete "/playlists/#{playlist_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end

  describe 'POST /playlists/:id/add/:song_id' do
    before { post "/playlists/#{playlist_id}/add/#{song.id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(201)
    end

    it 'adds the song to the playlist' do
      expect(Playlist.first.songs.count).to eq(1)
    end
  end

  describe 'DELETE /playlists/:id/remove/:song_id' do
    before(:each) do
      PlaylistSong.create(song: song, playlist: playlists.first) 
    end
    before { delete "/playlists/#{playlist_id}/remove/#{song.id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the song from the playlist' do
      expect(Playlist.first.songs.count).to eq(0)
    end
  end
end
