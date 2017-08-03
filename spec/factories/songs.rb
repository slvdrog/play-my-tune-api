FactoryGirl.define do
  factory :song do
    name { Faker::Pokemon.name }
    genre { Faker::Pokemon.location }
    duration { Faker::Number.number(1000) }
    featured false
    artist_id nil
    album_id nil
    playlist_id nil
  end
end