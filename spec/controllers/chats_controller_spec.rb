require 'rails_helper'

RSpec.describe ChatsController, type: :controller do
  let(:application) { FactoryBot.create(:application) }  # Assumes you have a factory for applications
  let(:chat) { create(:chat, application: application) }

  describe "GET #index" do
    it "returns all chats for the application" do
      FactoryBot.create_list(:chat, 3, application: application)
      get :index, params: { application_token: application.token }
      expect(json.size).to eq(3)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #show" do
    it "returns the chat" do
      get :show, params: { application_token: application.token, number: chat.number }
      expect(json['name']).to eq(chat.name)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST #create" do
    let(:name) { 'General Discussion' }

    it "enqueues chat creation" do
      expect {
        post :create, params: { application_token: application.token, name: name }
      }.to change { $redis.llen("chat_queue") }.by(1)
      expect(response).to have_http_status(:accepted)
    end
  end

  describe "PUT #update" do

    it "updates the chat" do
      put :update, params: { application_token: application.token, number: chat.number,  name: 'Support' }
      chat.reload
      expect(chat.name).to eq('Support')
      expect(response).to have_http_status(:ok)
    end
  end

  describe "DELETE #destroy" do
    let!(:chat) { FactoryBot.create(:chat, application: application) }

    it "destroys the chat" do
      expect {
        delete :destroy, params: { application_token: application.token, number: chat.number }
      }.to change(Chat, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end