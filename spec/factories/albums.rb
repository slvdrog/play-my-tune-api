FactoryGirl.define do
  factory :album do
    name { Faker::DrWho.villian }
    art { Faker::Internet.url }
    artist_id nil
  end
end