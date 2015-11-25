if defined?(Algolia)
  application_id = GojiLabs.var('ALGOLIA_APPLICATION_ID')
  api_key = GojiLabs.var('ALGOLIA_API_KEY')

  raise "Algolia application ID is blank" unless application_id
  raise "Algolia API key is blank" unless api_key

  Algolia.init application_id: application_id, api_key: api_key
 end
