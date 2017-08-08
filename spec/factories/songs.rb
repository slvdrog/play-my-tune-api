FactoryGirl.define do
  factory :song do
    name { Faker::Pokemon.name }
    genre { Faker::Pokemon.location }
    duration { Faker::Number.number(3) }
    featured false
    artist_id nil
    album_id nil
  end
end