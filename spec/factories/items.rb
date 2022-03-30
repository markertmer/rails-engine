FactoryBot.define do
  factory :item do
    name { Faker::Lorem.word }
    description { Faker::ChuckNorris.fact }
    unit_price { Faker::Number.decimal(l_digits:2) }
    merchant_id { Faker::Number.between(from: 1, to: 1000) }
  end
end
