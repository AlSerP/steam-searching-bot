require 'active_record'
require 'sqlite3'

require_relative '../migrations/migration'
require_relative '../bot/models'

class Database
  class << self
    def configure
      ActiveRecord::Base.logger = Logger.new(STDERR)

      ActiveRecord::Base.establish_connection(
        adapter: 'sqlite3',
        database: 'db/bot.sqlite3'
      )

      return false unless database_exists?
      
      # migrate unless ActiveRecord::Base.connection.table_exists?('favorites')
      migrate

      true
    end

    def migrate
      create_migrations_table unless ActiveRecord::Base.connection.table_exists?('migrations')

      migrations_applied = false

      migrations = Dir[File.join(__dir__, '../migrations/', '*.rb')]
      migrations.delete('migrations.rb')

      migrations.each do |file|
        migration_hash = migration_to_hash(file)
        next if Migration.find_by(migration_hash: migration_hash)

        ActiveRecord::Base.logger.info "Migrate === #{migration_hash}"

        require_relative file
        Migration.create!(migration_hash: migration_hash)
        migrations_applied = true

        ActiveRecord::Base.logger.info "Migration completed === #{migration_hash}"
      end

      ActiveRecord::Base.logger.info(migrations_applied ? "Done migrating" : "No migrations to apply")
      
    end

    def create_migrations_table
      ActiveRecord::Base.logger.info "=== Creating base migration"
      ActiveRecord::Schema.define do
        create_table :migrations do |table|
            table.column :migration_hash, :string
        end
      end
      ActiveRecord::Base.logger.info "=== Done"
    end

    def migration_to_hash(file)
      file.split('/')[-1].sub('.rb', '')
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
