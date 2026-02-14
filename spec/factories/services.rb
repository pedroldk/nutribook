FactoryBot.define do
  factory :service do
    name { "MyString" }
    price { "9.99" }
    location { "MyString" }
    latitude { 1.5 }
    longitude { 1.5 }
    association :nutritionist
  end
end
