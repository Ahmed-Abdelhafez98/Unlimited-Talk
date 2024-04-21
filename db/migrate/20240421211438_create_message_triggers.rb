class CreateMessageTriggers < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      CREATE TRIGGER increment_message_number
      BEFORE INSERT ON messages
      FOR EACH ROW
      BEGIN
        DECLARE max_number INT;
        -- Select the maximum number from messages where the chat_id matches the new row's chat_id
        SELECT COALESCE(MAX(number), 0) INTO max_number FROM messages WHERE chat_id = NEW.chat_id;
        -- Increment the max_number by 1 and set it to the new row's number
        SET NEW.number = max_number + 1;
      END;
    SQL

    execute <<-SQL
      CREATE TRIGGER update_message_count
      AFTER INSERT ON messages
      FOR EACH ROW
      BEGIN
        -- Update messages_count in the chats table
        UPDATE chats
        SET messages_count = messages_count + 1
        WHERE id = NEW.chat_id;
      END;
    SQL
  end

  def down
    execute <<-SQL
      DROP TRIGGER IF EXISTS increment_message_number;
    SQL
    execute <<-SQL
      DROP TRIGGER IF EXISTS update_message_count;
    SQL
  end
end