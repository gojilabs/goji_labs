
# we utilize PostgreSQL's schemas for segmenting our projects within the same database, this works with Heroku Postgres
if defined?(ActiveRecord::ConnectionAdapters::PostgreSQLAdapter)
  namespace :db do
    desc 'Create schemas for Goji Labs PostgreSQL project'
    task :create_schemas => :environment  do
      ActiveRecord::Base.connection.execute "CREATE SCHEMA IF NOT EXISTS #{GojiLabs.project_name}"
      ActiveRecord::Base.connection.execute 'CREATE SCHEMA IF NOT EXISTS shared_extensions;'
      ActiveRecord::Base.connection.execute 'CREATE EXTENSION IF NOT EXISTS HSTORE SCHEMA shared_extensions;'
      ActiveRecord::Base.connection.execute 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp" SCHEMA shared_extensions;'
    end
  end

  Rake::Task["db:test:purge"].enhance do
    Rake::Task["db:create_schemas"].invoke
  end

  Rake::Task["db:create"].enhance do
    Rake::Task["db:create_schemas"].invoke
  end
end
