namespace :es do
  desc "Reindex all Message records into Elasticsearch"
  task reindex_messages: :environment do
    puts "Reindexing all messages..."
    Message.find_in_batches do |batch|
      bulk_data = batch.map do |message|
        { index: { _id: message.id, data: message.as_indexed_json } }
      end
      Message.__elasticsearch__.client.bulk(index: Message.index_name, body: bulk_data)
    end
    puts "Reindexing complete."
  end
end