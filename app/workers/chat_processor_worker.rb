class ChatProcessorWorker
  include Sidekiq::Worker

  BATCH_SIZE = 10

  def perform
    chat_data_jsons = $redis.lrange("chat_queue", 0, BATCH_SIZE - 1)
    if chat_data_jsons.empty?
      Sidekiq.logger.info "No more chats to process."
      return
    end

      chat_records = chat_data_jsons.map do |chat_data_json|
        JSON.parse(chat_data_json).symbolize_keys
      end

      begin
      Chat.insert_all(chat_records)

      $redis.ltrim("chat_queue", BATCH_SIZE, -1)
      rescue => e
        handle_error(e)
      end
    self.class.perform_async
  end

  private

  def handle_error(exception)
    Sidekiq.logger.error "Failed to insert chats: #{exception.message}, retrying..."
    $redis.ltrim("chat_queue", 1, -1)
  end
end
