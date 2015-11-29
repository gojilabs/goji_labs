if defined?(Algolia)
  application_id = ENV['ALGOLIA_APPLICATION_ID']
  api_key = ENV['ALGOLIA_API_KEY']

  raise "Algolia application ID is blank" unless application_id && application_id.length > 0
  raise "Algolia API key is blank" unless api_key && api_key.length > 0

  Algolia.init application_id: application_id, api_key: api_key
 end
