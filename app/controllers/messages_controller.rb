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
    @message = @chat.messages.build(message_params)
    if @message.save
      render json: @message.as_json(except: [:id, :chat_id]), status: :created
    else
      render json: @message.errors, status: :unprocessable_entity
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

  def message_params
    params.permit(:body)
  end
end
