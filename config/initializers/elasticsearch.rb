require 'elasticsearch/model'

Elasticsearch::Model.client = Elasticsearch::Client.new(host: 'http://elasticsearch:9200')