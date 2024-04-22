namespace :es do
  desc "Reindex all Message records into Elasticsearch"
  task reindex_messages: :environment do
    ElasticsearchReindexService.reindex_messages
  end
end