require 'rails_helper'

RSpec.describe Chat, type: :model do
  let(:application) { FactoryBot.create(:application) }
  let(:chat) { build(:chat, application: application) }

  describe '#set_default_number' do
    it 'automatically sets the number before validation on create' do
      chat = Chat.new(name: 'Test Chat', application: application)
      chat.valid?
      expect(chat.number).to eq(1)
    end

    it 'increments numbers correctly with existing chats' do
      existing_chat = FactoryBot.create(:chat, application: application, number: 1)
      new_chat = Chat.create(name: 'Another Test Chat', application: application)
      expect(new_chat.number).to eq(2)
    end
  end
end