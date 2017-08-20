class SongsController < ApplicationController
  before_action :load_parent_resource, only: [:index, :create, :shuffle]
  before_action :load_song, only: [:show, :update, :destroy]

  caches_action :index, :show

  resource_description do
    short 'Songs endpoint'
    formats ['json']
    error 404, "Missing"
    error 500, "Server crashed "
    error 422, "Could not save the entity."
    error 401, "Bad request"
    description "Song Management"
  end

  # GET /artists/:artist_id/albums/:album_id/songs
  api!
  param :search, String, desc: "Search term for Song name"
  def index
    if params[:search]
      @songs = @parent_resource.songs.where('name LIKE ?', "%#{params[:search]}%")
    else
      @songs = @parent_resource.songs
    end
    json_response(@songs)
  end

  # POST /artists/:artist_id/albums/:album_id/song
  api!
  param :name, String, required: true, desc: "Song name"
  param :duration, String, required: true, desc: "Song duration"
  param :genre, String, desc: "Song genre"
  param :featured, [:true, :false], desc: "Is song featured?" 
  def create
    @song = @parent_resource.songs.create!(song_params)
    json_response(@song, :created)
  end

  # GET /artists/:artist_id/albums/:album_id/songs/:id
  api!
  param :id, String, required: true, desc: "Song id"
  def show
    json_response(@song)
  end

  # PUT /artists/:artist_id/albums/:album_id/songs/:id
  api!
  param :id, String, required: true, desc: "Song id"
  param :name, String, desc: "Song name"
  param :duration, String, desc: "Song duration"
  param :genre, String, desc: "Song genre"
  param :featured, [:true, :false], desc: "Is song featured?" 
  def update
    @song.update(song_params)
    head :no_content
  end

  # DELETE /artists/:artist_id/albums/:album_id/songs/:id
  api!
  param :id, String, required: true, desc: "Song id"
  def destroy
    @song.destroy
    head :no_content
  end

  def shuffle
    @songs = @parent_resource.songs.order("RANDOM()")
    json_response(@songs)
  end

  private

  def song_params
    # whitelist params
    params.permit(:name, :duration, :genre, :featured, :artist_id, :album_id)
  end

  def load_parent_resource
    if params[:album_id].present?
      @parent_resource = Artist.find(params[:artist_id]).albums.find(params[:album_id])
    else
      @parent_resource = Artist.find(params[:artist_id])
    end  
  end

  def load_song
    if params[:album_id].present?
      @song = Artist.find(params[:artist_id]).albums.find(params[:album_id]).songs.find(params[:id])
    else
      @song = Artist.find(params[:artist_id]).songs.find(params[:id])
    end
  end
end
