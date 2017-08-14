class PlaylistsController < ApplicationController
  before_action :load_playlist, only: [:show, :update, :destroy]
  before_action :load_playlist_and_song, only: [:add_song, :remove_song]

  caches_action :index, :show

  # GET /playlists
  def index
    @playlists = Playlist.all
    json_response(@playlists)
  end

  # POST /playlists
  def create
    @playlist = Playlist.create!(playlist_params)
    json_response(@playlist, :created)
  end

  # GET /playlists/:id
  def show
    render json: @playlist, include: :songs, status: status
  end

  # PUT /playlists/:id
  def update
    @playlist.update(playlist_params)
    head :no_content
  end

  # DELETE /playlists/:id
  def destroy
    @playlist.destroy
    head :no_content
  end

  def add_song
    @playlist_song = PlaylistSong.create!(song: @song, playlist: @playlist) 
    json_response(@playlist_song, :created)
  end

  def remove_song
    PlaylistSong.where(song_id: @song.id, playlist_id: @playlist.id).first.destroy!
    head :no_content
  end

  private

  def playlist_params
    params.permit(:name)
  end

  def load_playlist
    @playlist = Playlist.find(params[:id])
  end

  def load_playlist_and_song
    @playlist = Playlist.find(params[:playlist_id])
    @song = Song.find(params[:song_id])
  end
end
