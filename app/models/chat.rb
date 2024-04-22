class Chat < ApplicationRecord
  belongs_to :application, counter_cache: true
  has_many :messages, dependent: :destroy

  before_validation :set_default_number, on: :create

  validates :name, presence: true
  validates :messages_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def set_default_number
    last_number = self.application.chats.maximum(:number) || 0
    self.number = last_number + 1
  end
end