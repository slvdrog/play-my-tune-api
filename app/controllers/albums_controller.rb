class AlbumsController < ApplicationController
  before_action :load_album, only: [:show, :update, :destroy]

  # GET /albums
  def index
    @albums = Album.all
    json_response(@albums)
  end

  # POST /albums
  def create
    @albums = Album.create!(album_params)
    json_response(@albums, :created)
  end

  # GET /albums/:id
  def show
    json_response(@album)
  end

  # PUT /albums/:id
  def update
    @album.update(album_params)
    head :no_content
  end

  # DELETE /albums/:id
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
