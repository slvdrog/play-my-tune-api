class ArtistsController < ApplicationController
  before_action :load_artist, only: [:show, :update, :destroy]

  caches_action :index, :show

  resource_description do
    short 'Artists endpoint'
    formats ['json']
    error 404, "Missing"
    error 500, "Server crashed "
    error 422, "Could not save the entity."
    error 401, "Bad request"
    description "Artist Management"
  end

  # GET /artists
  api!
  def index
    @artists = Artist.all
    json_response(@artists)
  end

  # GET /artists/:id
  api!
  param :id, String, required: true, desc: "Artist's id"
  def show
    json_response(@artist)
  end

  # POST /artists
  api!
  param :name, String, required: true, desc: "Artist's name"
  param :bio, String, desc: "Artist's bio"
  def create
    @artist = Artist.create!(artist_params)
    json_response(@artist, :created)
  end

  # PUT /artists/:id
  api!
  param :id, String, required: true, desc: "Artist's id"
  param :name, String, desc: "Artist's name"
  param :bio, String, desc: "Artist's bio"
  def update
    @artist.update(artist_params)
    head :no_content
  end

  # DELETE /artists/:id
  api!
  param :id, String, required: true, desc: "Artist's id"
  def destroy
    @artist.destroy
    head :no_content
  end

  private

  def artist_params
    # whitelist params
    params.permit(:name, :bio)
  end

  def load_artist
    @artist = Artist.find(params[:id])
  end
end
