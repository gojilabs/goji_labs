require 'rails/railtie'

module GojiLabs
  class Railtie < Rails::Railtie

    rake_tasks do
      load File.expand_path('../../tasks/db.rake', __FILE__)
    end

    initializer 'goji_labs.load_project' do |app|
      ENV['PROJECT_NAME'] ||= app.class.parent.name.underscore

      if defined?(Sidekiq)
        app.config.active_job.queue_adapter = :sidekiq
        app.config.active_job.queue_name_prefix = "#{GojiLabs.project_name}.#{GojiLabs.env}"
        app.config.active_job.queue_name_delimiter = '.'
      end

      GojiLabs.load_project
    end
  end
end
