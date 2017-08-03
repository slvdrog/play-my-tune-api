class Song < ApplicationRecord
  belongs_to :artist
  belongs_to :album
  belongs_to :playlist

  validates_presence_of :name, :duration
end
