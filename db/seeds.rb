# Seed Applications
Application.create
([
  { name: "ChatApp" },
  { name: "MessagingService" },
  { name: "NotificationSystem" }
])

# Seed Chats
Application.all.each do |app|
  5.times do |i|
    app.chats.create!(messages_count: 0, name: "Chat #{i + 1}")
  end
end


# Seed Messages
Chat.all.each do |chat|
  10.times do |i|
    Message.create(chat_id: chat.id, body: "Message #{i + 1} in Chat #{chat.number}")
  end
end