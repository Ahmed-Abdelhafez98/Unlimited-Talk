class Chat < ApplicationRecord
  belongs_to :application, counter_cache: true
  has_many :messages, dependent: :destroy

  validates :number, presence: true, uniqueness: { scope: :application_id }
  validates :name, presence: true
  validates :messages_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

end