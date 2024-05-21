require 'sqlite3'

require_relative '../migrations/migration'
# require_relative '../bot/models'

class Database
  class << self
    def configure
      ActiveRecord::Base.logger = Logger.new('logs/db.log')

      ActiveRecord::Base.establish_connection(
        adapter: 'sqlite3',
        database: 'db/bot.sqlite3'
      )

      return false unless database_exists?

      migrate

      true
    end

    def migrate
      create_migrations_table unless ActiveRecord::Base.connection.table_exists?('migrations')

      applied = 0

      migration_files.each do |file|
        next if migration_applied?(file)

        apply_migration(file)
        applied += 1
      end

      logger.info(applied.positive? ? "Done migrating: #{applied}" : 'No migrations to apply')
    end

    def database_exists?
      ActiveRecord::Base.connection
    rescue ActiveRecord::NoDatabaseError
      false
    else
      true
    end

    def log_current_models_report
      logger.info "Current Users: #{User.count}"
      logger.info "Current Favorites: #{Favorite.count}"
    end

    private

    def migration_applied?(migration_file)
      migration_hash = migration_to_hash(migration_file)
      Migration.find_by(migration_hash: migration_hash).present?
    end

    def apply_migration(migration_file)
      migration_hash = migration_to_hash(migration_file)
      require_relative migration_file
      Migration.create!(migration_hash: migration_hash)

      logger.info "Migration applied === #{migration_hash}"
    end

    def migration_to_hash(file)
      file.split('/')[-1].sub('.rb', '')
    end

    def create_migrations_table
      ActiveRecord::Base.logger.info '=== Creating base migration'
      ActiveRecord::Schema.define do
        create_table :migrations do |table|
          table.column :migration_hash, :string
        end
      end
      ActiveRecord::Base.logger.info '=== Done'
    end

    def migration_files
      migrations = Dir[File.join(__dir__, '../migrations/', '*.rb')]
      migrations.delete('migrations.rb')

      migrations
    end

    def logger
      ActiveRecord::Base.logger
    end
  end
end
