if defined?(Algolia)
  application_id = GojiLabs.var('ALGOLIA_APPLICATION_ID')
  api_key = GojiLabs.var('ALGOLIA_API_KEY')

  raise "Algolia application ID is blank" if application_id.blank?
  raise "Algolia API key is blank" if api_key.blank?
  
  Algolia.init application_id: application_id, api_key: api_key
 end
