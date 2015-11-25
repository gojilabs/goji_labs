
if defined?(Sidekiq)

  redis_connection_details = {
    redis_url: "redis://#{ENV['SIDEKIQ_REDIS_HOST'] || 'localhost'}:#{ENV['SIDEKIQ_REDIS_PORT'] || 6379}/",
    namespace: Rails.application.class.parent.name.underscore
  }

  Sidekiq.configure_client do |config|
    config.redis = redis_connection_details
  end

  Sidekiq.configure_server do |config|
    config.redis = redis_connection_details

    # Heroku sets DATABASE_URL
    # For concurrency and High IO:
    # See: https://github.com/mperham/sidekiq/wiki/Advanced-Options
    database_url = ENV['DATABASE_URL']
    if (database_url)
      concurrency = Sidekiq.options[:concurrency].to_i
      # This will be the case on Heroku deployed environments
      uri = URI.parse(database_url)
      puts "Original DATABASE_URL => #{uri}"
      pool_size = (concurrency * 1.6).round(0)
      params = {}
      params['pool'] = pool_size
      uri.query = "#{params.to_query}"
      ENV['DATABASE_URL'] = uri.to_s
      puts "Sidekiq Server is reconnecting with new pool size: #{params['pool']} - DATABASE_URL => #{uri}"
      ActiveRecord::Base.establish_connection
    else
      # This will be the case in local environments (development & test)
      # Even trying to limit the concurrency results in too many connections.
      # So we just go with one per queue unless specified as ENV['SIDEKIQ_CONCURRENCY'].
      if ENV['SIDEKIQ_CONCURRENCY']
        Sidekiq.options[:concurrency] = ENV['SIDEKIQ_CONCURRENCY'].to_i
      else
        Sidekiq.options[:concurrency] = 1
      end
    end

    config.server_middleware do |chain|
      if heroku && ENV['HEROKU_PROCESS'] && heroku[ENV['HEROKU_PROCESS']]
        p("Setting up auto-scaleer server middleware")
        chain.add(Autoscaler::Sidekiq::Server, heroku[ENV['HEROKU_PROCESS']], 230, [ENV['HEROKU_PROCESS']])
      else
        p("Not scaleable server middleware")
      end
    end

    # Because our jobs running in the server can schedule other jubs, thus acting as clients,
    # we have to setup the client middleware in the server as well.
    # https://github.com/mperham/sidekiq/wiki/Middleware
    # https://github.com/mperham/sidekiq/issues/545
    # https://github.com/mperham/sidekiq/issues/175
    # https://github.com/JustinLove/autoscaler/issues/9#issuecomment-14069013
    config.client_middleware do |chain|
      if heroku && ENV['HEROKU_PROCESS'] && heroku[ENV['HEROKU_PROCESS']]
        p("Setting up auto-scaleer server-as-client middleware")
        chain.add Autoscaler::Sidekiq::Client, heroku
      else
        p("Not scaleable server-as-client middleware")
      end
    end
  end
end
