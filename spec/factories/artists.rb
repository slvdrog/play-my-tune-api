FactoryGirl.define do
  factory :artist do
    name { Faker::DrWho.character }
    bio { Faker::DrWho.quote }
  end
end