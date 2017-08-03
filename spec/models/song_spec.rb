require 'rails_helper'

RSpec.describe Song, type: :model do
  it { should belong_to(:albums) }
  it { should belong_to(:artist) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:duration) }
end
