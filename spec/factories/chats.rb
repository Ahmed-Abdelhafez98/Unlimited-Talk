FactoryBot.define do
  factory :chat do
    application
    name { "Chat #{Faker::Lorem.word}" }
  end
end
