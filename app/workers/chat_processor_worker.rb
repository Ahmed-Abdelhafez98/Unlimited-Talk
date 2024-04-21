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

      # After successful processing, remove these items from the queue
      $redis.ltrim("chat_queue", BATCH_SIZE, -1)

      self.class.perform_async
      rescue => e
        Sidekiq.logger.error "Failed to insert chats: #{e.message}"
      end
  end
end
