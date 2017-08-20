class AlbumsController < ApplicationController
  before_action :load_album, only: [:show, :update, :destroy]

  caches_action :index, :show

  resource_description do
    short 'Albums endpoint'
    formats ['json']
    error 404, "Missing"
    error 500, "Server crashed "
    error 422, "Could not save the entity."
    error 401, "Bad request"
    description "Album Management"
  end

  # GET /artist/albums
  api!
  def index
    @albums = Album.all
    json_response(@albums)
  end

  # POST /albums
  api!
  param :name, String, required: true, desc: "Album's name"
  param :art, String, desc: "Album's cover_art"
  def create
    @albums = Album.create!(album_params)
    json_response(@albums, :created)
  end

  # GET /albums/:id
  api!
  param :id, String, required: true, desc: "Album's id"
  def show
    render json: @album, include: :songs, status: status
  end

  # PUT /albums/:id
  api!
  param :id, String, required: true, desc: "Album's id"
  param :name, String, desc: "Album's name"
  param :art, String, desc: "Album's cover_art"
  def update
    @album.update(album_params)
    head :no_content
  end

  # DELETE /albums/:id
  api!
  param :id, String, required: true, desc: "Album's id"
  def destroy
    @album.destroy
    head :no_content
  end

  private

  def album_params
    # whitelist params
    params.permit(:name, :art, :artist_id)
  end

  def load_album
    @album = Album.find(params[:id])
  end
end
