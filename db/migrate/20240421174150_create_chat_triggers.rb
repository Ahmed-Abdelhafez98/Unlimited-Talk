class CreateChatTriggers < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      CREATE TRIGGER increment_chat_number
      BEFORE INSERT ON chats
      FOR EACH ROW
      BEGIN
        DECLARE max_number INT;
        SELECT COALESCE(MAX(number), 0) INTO max_number FROM chats WHERE application_id = NEW.application_id;
        SET NEW.number = max_number + 1;
      END;
    SQL

    execute <<-SQL
      CREATE TRIGGER update_chat_count
      AFTER INSERT ON chats
      FOR EACH ROW
      BEGIN
        UPDATE applications
        SET chats_count = chats_count + 1
        WHERE id = NEW.application_id;
      END;
    SQL
  end

  def down
    execute <<-SQL
      DROP TRIGGER IF EXISTS increment_chat_number;
    SQL
    execute <<-SQL
      DROP TRIGGER IF EXISTS update_chat_count;
    SQL
  end
end
