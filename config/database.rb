require 'pg'

class Database
  class << self
    def configure
      ActiveRecord::Base.logger = Logger.new(Bot::Config::DB_LOGS)

      ActiveRecord::Base.establish_connection(
        adapter: 'postgresql',
        host: ENV['DATABASE_HOST'],
        port: ENV['DATABASE_PORT'] || 5432,
        username: ENV['DATABASE_USERNAME'],
        password: ENV['DATABASE_PASSWORD'],
        database: ENV['DATABASE_DATABASE']
      )

      return false unless database_exists?

      true
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
