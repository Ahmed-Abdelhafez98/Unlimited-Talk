class MessagesController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :set_application
  before_action :set_chat
  before_action :set_message, only: [:show]

  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 10

    if params[:query].present?
      @messages = @chat.messages.search(@chat.id, params[:query], page, per_page).records
    else
      @messages = @chat.messages
    end

    render json: @messages.as_json(except: [:id, :chat_id])
  end

  def show
    render json: @message.as_json(except: [:id, :chat_id])
  end

  def create
    if valid_body?(message_params[:body])
    message_data = {
      chat_id: @chat.id,
      body: message_params[:body],
    }

    begin
      $redis.rpush("message_queue", message_data.to_json)
      render json: { message: "Message creation in progress." }, status: :accepted
    rescue Redis::CannotConnectError
      render json: { error: "Unable to connect to Redis" }, status: :service_unavailable
    end
    else
      render json: { error: "Invalid message name" }, status: :unprocessable_entity
    end
  end

  private

  def set_application
    @application = Application.find_by!(token: params[:application_token])
  end

  def set_chat
    @chat = @application.chats.find_by!(number: params[:chat_number])
  end

  def set_message
    @message = @chat.messages.find_by!(number: params[:number])
  end

  def valid_body?(body)
    body.present? && body.strip != ""
  end

  def message_params
    params.permit(:body)
  end
end
