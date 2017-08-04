class AlbumsController < ApplicationController
  before_action :load_albums, only: [:show, :update, :destroy]

  # GET /albums
  def index
    @albums = Album.all
    json_response(@albums)
  end

  # POST /albums
  def create
    @albums = Album.create!(albums_params)
    json_response(@albums, :created)
  end

  # GET /albums/:id
  def show
    json_response(@albums)
  end

  # PUT /albums/:id
  def update
    @albums.update(albums_params)
    head :no_content
  end

  # DELETE /albums/:id
  def destroy
    @albums.destroy
    head :no_content
  end

  private

  def albums_params
    # whitelist params
    params.permit(:name, :art)
  end

  def load_albums
    @albums = Album.find(params[:id])
  end
end
