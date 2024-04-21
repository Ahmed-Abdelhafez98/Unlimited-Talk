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
    @chat = @application.chats.build(chat_params)

    if @chat.save
      render json: @chat.as_json(except: [:id, :application_id]), status: :created, location: [@application, @chat]
    else
      render json: @chat.errors, status: :unprocessable_entity
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
