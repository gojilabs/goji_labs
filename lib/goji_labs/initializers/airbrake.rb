if defined?(Airbrake)
  api_key = ENV["AIRBRAKE_API_KEY"]

  raise "Airbrake API key is blank" unless api_key && api_key.length > 0

  Airbrake.configure do |config|
    config.api_key = api_key
    config.environment_name = GojiLabs.env
  end
end
