class Song < ApplicationRecord
  belongs_to :artist
  belongs_to :album

  validates_presence_of :name, :duration
end
