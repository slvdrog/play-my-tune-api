class PlaylistsController < ApplicationController
  before_action :load_playlist, only: [:show, :update, :destroy]
  before_action :load_playlist_and_song, only: [:add_song, :remove_song]

  caches_action :index, :show

  resource_description do
    short 'Playlists endpoint'
    formats ['json']
    error 404, "Missing"
    error 500, "Server crashed "
    error 422, "Could not save the entity."
    error 401, "Bad request"
    description "Playlist Management"
  end

  api!
  def index
    @playlists = Playlist.all
    json_response(@playlists)
  end

  api!
  param :name, String, required: true, desc: "Playlist name"
  def create
    @playlist = Playlist.create!(playlist_params)
    json_response(@playlist, :created)
  end

  api!
  param :id, String, required: true, desc: "Playlist id"
  def show
    render json: @playlist, include: :songs, status: status
  end

  # PUT /playlists/:id
  api!
  param :id, String, required: true, desc: "Playlist id"
  param :name, String, desc: "Playlist name"
  def update
    @playlist.update(playlist_params)
    head :no_content
  end

  # DELETE /playlists/:id
  api!
  param :id, String, required: true, desc: "Playlist id"
  def destroy
    @playlist.destroy
    head :no_content
  end

  api!
  param :song_id, String, required: true, desc: "Song id"
  param :playlist_id, String, required: true, desc: "Playlist id"
  def add_song
    @playlist_song = PlaylistSong.create!(song: @song, playlist: @playlist) 
    json_response(@playlist_song, :created)
  end

  api!
  param :song_id, String, required: true, desc: "Song id"
  param :playlist_id, String, required: true, desc: "Playlist id"
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
