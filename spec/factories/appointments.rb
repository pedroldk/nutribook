FactoryBot.define do
  factory :appointment do
    guest_name { "MyString" }
    guest_email { "MyString" }
    start_time { "2026-02-10 18:48:18" }
    status { 1 }
    association :service
  end
end
