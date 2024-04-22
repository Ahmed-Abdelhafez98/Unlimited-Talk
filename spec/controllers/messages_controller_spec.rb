require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  let(:application) { create(:application) }
  let(:chat) { create(:chat, application: application) }

  describe "GET #index" do
    context "without search query" do
      it "returns all messages" do
        create_list(:message, 3, chat: chat)
        get :index, params: { application_token: application.token, chat_number: chat.number }
        expect(response).to have_http_status(:ok)
        expect(json.size).to eq(3)
      end
    end

    context "with search query" do
      it "returns filtered messages" do
        message1 = create(:message, chat: chat, body: "hello world")
        message2 = create(:message, chat: chat, body: "hello universe")
        Message.__elasticsearch__.refresh_index!
        get :index, params: { application_token: application.token, chat_number: chat.number, query: "world" }
        expect(response).to have_http_status(:ok)
        expect(json.size).to eq(1)
        expect(json.first['body']).to include("world")
      end
    end
  end

  describe "GET #show" do
    let(:message) { create(:message, chat: chat) }

    it "returns the message" do
      get :show, params: { application_token: application.token, chat_number: chat.number, number: message.number }
      expect(response).to have_http_status(:ok)
      expect(json['body']).to eq(message.body)
    end
  end

  describe "POST #create" do
    let(:message_params) { { body: 'New message' } }

    it "enqueues message creation" do
      expect {
        post :create, params: { application_token: application.token, chat_number: chat.number, body: message_params[:body] }
      }.to change { $redis.llen("message_queue") }.by(1)
      expect(response).to have_http_status(:accepted)
    end
  end
end