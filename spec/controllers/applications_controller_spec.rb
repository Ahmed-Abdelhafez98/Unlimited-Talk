require 'rails_helper'
require 'faker'
require 'factory_bot_rails'

RSpec.describe ApplicationsController, type: :controller do
  describe "GET #index" do
    it "returns a successful response" do
      get :index
      expect(response).to be_successful
      expect(response.status).to eq(200)
    end

    it "returns all applications" do
      get :index
      old = json.size
      create_list(:application, 3)
      get :index
      expect(json.size).to eq(old + 3)
    end
  end

  describe "GET #show" do
    it "returns the application" do
      application = create(:application)  # Create a sample application
      get :show, params: { token: application.token }
      expect(response).to be_successful
      expect(json['name']).to eq(application.name)
    end
  end

  describe "POST #create" do
    it "creates a new application" do
      expect {
        post :create, params: { name: 'New App' }
      }.to change(Application, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it "returns errors for invalid parameters" do
      post :create, params: { name: '' }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PUT #update" do
    let!(:application) { create(:application) }

    it "updates the application" do
      put :update, params: { token: application.token, name: 'Updated Name' }
      application.reload
      expect(application.name).to eq('Updated Name')
      expect(response).to be_successful
    end
  end

  describe "DELETE #destroy" do
    let!(:application) { create(:application) }

    it "deletes the application" do
      expect {
        delete :destroy, params: { token: application.token }
      }.to change(Application, :count).by(-1)
      expect(response).to have_http_status(:no_content)  # or :success, depending on implementation
    end
  end
end
