require 'rails_helper'

RSpec.describe Application, type: :model do

  describe '#generate_token' do
    it 'generates a unique token before creation' do
      application = Application.create(name: 'New App')
      expect(application.token).not_to be_nil
      expect(application.token.size).to eq(20)  # since SecureRandom.hex(10) generates a 20 character string
    end

    it 'ensures the token is unique' do
      existing_application = FactoryBot.create(:application)
      allow(SecureRandom).to receive(:hex).and_return(existing_application.token, 'unique_token1234567890')
      application = Application.create(name: 'Another App')
      expect(application.token).not_to eq(existing_application.token)
    end
  end
end
