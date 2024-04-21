class MessageProcessorWorker
  include Sidekiq::Worker

  BATCH_SIZE = 10  # Set the batch size as per your throughput needs

  def perform
    message_data_jsons = $redis.lrange("message_queue", 0, BATCH_SIZE - 1)
    if message_data_jsons.empty?
      Sidekiq.logger.info "No more messages to process."
      return
    end

    message_records = message_data_jsons.map do |message_data_json|
      JSON.parse(message_data_json).symbolize_keys
    end

    begin
      Message.insert_all(message_records)
      # After successful insertion, remove these items from the queue
      $redis.ltrim("message_queue", BATCH_SIZE, -1)

      self.class.perform_async
    rescue => e
      Sidekiq.logger.error "Failed to insert messages: #{e.message}"
    end
  end
end
