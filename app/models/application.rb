class Application < ApplicationRecord
  has_many :chats, dependent: :destroy

  validates :name, presence: true
  validates :token, presence: true, uniqueness: true

  before_validation :generate_token, on: :create

  private

  def generate_token
    begin
      self.token = SecureRandom.hex(10)
    end while self.class.exists?(token: token)
  end
end