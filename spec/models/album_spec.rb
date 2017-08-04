require 'rails_helper'

RSpec.describe Album, type: :model do
  it { should belong_to(:artist) }
  it { should have_many(:songs).dependent(:destroy) }
  it { should validate_presence_of(:name) }
end
