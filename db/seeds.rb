# Seed Applications
Application.create
([
  { name: "ChatApp", token: SecureRandom.hex(10) },
  { name: "MessagingService", token: SecureRandom.hex(10) },
  { name: "NotificationSystem", token: SecureRandom.hex(10) }
])

# Seed Chats
Application.all.each do |app|
  5.times do |i|
    app.chats.create!(number: i + 1, messages_count: 0, name: "Chat #{i + 1}")
  end
end


# Seed Messages
Chat.all.each do |chat|
  10.times do |i|
    Message.create(chat_id: chat.id, number: i + 1, body: "Message #{i + 1} in Chat #{chat.number}")
  end
end