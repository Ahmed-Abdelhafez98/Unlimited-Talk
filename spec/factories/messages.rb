FactoryBot.define do
  factory :message do
    chat
    body { "Message body #{Faker::Lorem.sentence}" }
  end
end