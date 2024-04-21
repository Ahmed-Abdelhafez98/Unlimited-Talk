require 'elasticsearch/model'
class Message < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  belongs_to :chat, counter_cache: true

  before_validation :assign_number, on: :create

  validates :number, presence: true, uniqueness: { scope: :chat_id }
  validates :body, presence: true

  def as_indexed_json(options = {})
    as_json
  end

  def self.search(chat_id, query, page, per_page)
    from_record = (page.to_i - 1) * per_page.to_i

    search_definition =
      {
        from: from_record,
        size: per_page,
        query: {
          "bool": {
            "must": [
              { wildcard: { body: "#{query}*" } },
              { term: { chat_id: chat_id } }
            ]
          }
        }
      }
    search_definition.merge!({})

    __elasticsearch__.search(search_definition)
  end

  private

  def assign_number
    self.number = chat.messages.maximum(:number).to_i + 1
  end
end