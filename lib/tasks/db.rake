
# we utilize PostgreSQL's schemas for segmenting our projects within the same database, this works with Heroku Postgres

namespace :db do

  def using_postgres?
    defined?(ActiveRecord::ConnectionAdapters::PostgreSQLAdapter)
  end

  def schemas_on?
    ENV['POSTGRESQL_SCHEMAS_ON'].to_s == 'true'
  end

  namespace :pg do

    desc 'Create schemas for Goji Labs PostgreSQL project'
    task create_schema: :environment  do
      if using_postgres?
        ActiveRecord::Base.connection.execute "CREATE SCHEMA IF NOT EXISTS #{GojiLabs.project_name}"
        ActiveRecord::Base.connection.execute 'CREATE SCHEMA IF NOT EXISTS shared_extensions;'
        ActiveRecord::Base.connection.execute 'CREATE EXTENSION IF NOT EXISTS HSTORE SCHEMA shared_extensions;'
        ActiveRecord::Base.connection.execute 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp" SCHEMA shared_extensions;'
      else
        puts "Not using PostgreSQL in this project, refusing to create schemas..."
      end
    end

    desc 'Drop project schema for Goji Labs PostgreSQL project'
    task drop_schema: :environment do
      if using_postgres?
        ActiveRecord::Base.connection.execute "DROP SCHEMA IF EXISTS #{GojiLabs.project_name} CASCADE"
      end
    end
  end
end

Rake::Task["db:test:purge"].enhance do
  Rake::Task["db:pg:create_schema"].invoke if schemas_on?
end

Rake::Task["db:create"].enhance do
  Rake::Task["db:pg:create_schema"].invoke if schemas_on?
end

Rake::Task["db:migrate"].enhance do
  Rake::Task["db:pg:create_schema"].invoke if schemas_on?
end
