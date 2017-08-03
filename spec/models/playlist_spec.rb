require 'rails_helper'

RSpec.describe Playlist, type: :model do
  it { should have_many(:songs) }
  it { should validate_presence_of(:name) }
end
