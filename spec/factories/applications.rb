FactoryBot.define do
  factory :application do
    name { "Test Application" }
    token { SecureRandom.hex(10) }
  end
end