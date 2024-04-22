require 'active_record'
require 'sqlite3'

class Database
  class << self
    def configure
      ActiveRecord::Base.logger = Logger.new(STDERR)

      ActiveRecord::Base.establish_connection(
        adapter: 'sqlite3',
        database: 'db/bot.sqlite3'
      )

      return false unless database_exists?
      
      migrate unless ActiveRecord::Base.connection.table_exists?('favorites')

      true
    end

    def migrate
      ActiveRecord::Schema.define do
        create_table :favorites do |table|
            table.column :item_hash, :string
            table.column :chat_id, :string
            table.column :price, :string
        end
      end
    end

    def database_exists?
      ActiveRecord::Base.connection
    rescue ActiveRecord::NoDatabaseError
      false
    else
      true
    end
  end
end
