require 'rails_helper'

RSpec.describe Message, type: :model do
  describe '#set_default_number' do
    let(:chat) { create(:chat) }

    it 'assigns a sequential number on creation' do
      create(:message, chat: chat, number: 1)
      new_message = create(:message, chat: chat)
      expect(new_message.number).to eq(2)
    end
  end

  describe '.search' do
    let(:chat) { create(:chat) }
    let!(:message1) { create(:message, chat: chat, body: 'Hello world') }
    let!(:message2) { create(:message, chat: chat, body: 'Hello Ruby') }

    it 'returns messages matching the search query' do
      # Assuming Elasticsearch is running and indexed
      Message.__elasticsearch__.refresh_index!
      results = Message.search(chat.id, 'world', 1, 10)
      expect(results.records.to_a).to include(message1)
      expect(results.records.to_a).not_to include(message2)
    end
  end
end
