class SongsController < ApplicationController
  before_action :load_artist_album, only: [:index, :create]
  before_action :load_song, only: [:show, :update, :destroy]

  caches_action :index, :show

  # GET /artists/:artist_id/albums/:album_id/songs
  def index
    @songs = @album.songs
    json_response(@songs)
  end

  # POST /artists/:artist_id/albums/:album_id/song
  def create
    @song = @album.songs.create!(song_params)
    json_response(@song, :created)
  end

  # GET /artists/:artist_id/albums/:album_id/songs/:id
  def show
    json_response(@song)
  end

  # PUT /artists/:artist_id/albums/:album_id/songs/:id
  def update
    @song.update(song_params)
    head :no_content
  end

  # DELETE /artists/:artist_id/albums/:album_id/songs/:id
  def destroy
    @song.destroy
    head :no_content
  end

  private

  def song_params
    # whitelist params
    params.permit(:name, :duration, :genre, :featured, :artist_id, :album_id)
  end

  def load_artist_album
    @album = Artist.find(params[:artist_id]).albums.find(params[:album_id])
  end

  def load_song
    @song = Artist.find(params[:artist_id]).albums.find(params[:album_id]).songs.find(params[:id])
  end
end
