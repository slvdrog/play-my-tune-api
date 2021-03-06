require 'rails_helper'

RSpec.describe Song, type: :model do
  it { should belong_to(:album) }
  it { should belong_to(:artist) }
  it { should have_many(:playlist_songs) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:duration) }
end
