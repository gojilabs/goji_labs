if defined?(Airbrake)
  api_key = GojiLabs.var("AIRBRAKE_API_KEY")

  raise "Airbrake API key is blank" if api_key.blank?

  Airbrake.configure do |config|
    config.api_key = api_key
    config.environment_name = GojiLabs.env
  end
end
