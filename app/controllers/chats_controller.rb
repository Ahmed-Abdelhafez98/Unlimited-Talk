class ChatsController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :set_application
  before_action :set_chat, only: [:show, :update, :destroy]

  def index
    @chats = @application.chats
    render json: @chats.as_json(except: [:id, :application_id])
  end

  def show
    render json: @chat.as_json(except: [:id, :application_id])
  end

  def create
    chat_data = {
      application_id: @application.id,
      name: chat_params[:name],
    }

    begin
      $redis.rpush("chat_queue", chat_data.to_json)
      render json: { message: "Chat creation in progress." }, status: :accepted
    rescue Redis::CannotConnectError
      render json: { error: "Unable to connect to Redis" }, status: :service_unavailable
    end
  end

  def update
    if @chat.update(chat_params)
      render json: @chat.as_json(except: [:id, :application_id])
    else
      render json: @chat.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @chat.destroy
    head :no_content
  end

  private

  def set_application
    @application = Application.find_by!(token: params[:application_token])
  end

  def set_chat
    @chat = @application.chats.find_by!(number: params[:number])
  end

  def chat_params
    params.permit(:name)
  end
end
