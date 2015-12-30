if defined?(Airbrake)
  project_key = ENV["AIRBRAKE_PROJECT_KEY"]
  project_id = ENV["AIRBRAKE_PROJECT_ID"]

  raise "Airbrake project key is blank" unless project_key && project_key.length > 0
  raise "Airbrake project ID is blank" unless project_id && project_id.length > 0

  Airbrake.configure do |config|
    config.project_id = project_id.to_i
    config.project_key = project_key
    config.environment = GojiLabs.env
    config.root_directory = Rails.root if defined?(Rails)
    config.ignore_environments = %w(test development)
  end
end
