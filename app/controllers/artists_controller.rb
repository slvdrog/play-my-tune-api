class ArtistsController < ApplicationController
  before_action :load_artist, only: [:show, :update, :destroy]

  # GET /artists
  def index
    @artists = Artist.all
    json_response(@artists)
  end

  # POST /artists
  def create
    @artist = Artist.create!(artist_params)
    json_response(@artist, :created)
  end

  # GET /artists/:id
  def show
    json_response(@artist)
  end

  # PUT /artists/:id
  def update
    @artist.update(artist_params)
    head :no_content
  end

  # DELETE /artists/:id
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
