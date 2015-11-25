module GojiLabs
  ENV_DEVELOPMENT = 'development'
  ENV_STAGING     = 'staging'
  ENV_PRODUCTION  = 'production'
  ENV_TEST        = 'test'

	def self.env
    ENV['GOJI_ENV'] || ENV['RAILS_ENV'] || ENV['RACK_ENV']
	end

	def self.development?
		env == ENV_DEVELOPMENT
	end

	def self.production?
		env == ENV_PRODUCTION
	end

	def self.staging?
		env == ENV_STAGING
	end

	def self.test?
		env == ENV_TEST
	end

  def self.var(environment_variable)
    ENV["#{project_name}_#{environment_variable.strip}".upcase.split.join('_')]
  end

  def self.project_name=(name)
    @@project_name = name
    adapter  = var('DATABASE_ADAPTER')  || 'postgresql'
    encoding = var('DATABASE_ENCODING') || 'unicode'
    host     = var('DATABASE_HOST')     || 'localhost'
    pool     = var('DATABASE_POOL')     || '30'
    port     = var('DATABASE_PORT')
    username = var('DATABASE_USERNAME')
    password = var('DATABASE_PASSWORD')
    database = "#{project_name}_#{env}".downcase.split.join('_')

    if username
      login = password ? "#{username}:#{password}@" : username
    else
      login = ''
    end
    database_url = "#{adapter}://#{login}#{host}"
    database_url = "#{database_url}:#{port}" if port
    database_url = "#{database_url}/#{database}?pool=#{pool}&encoding=#{encoding}"

    ENV['DATABASE_URL'] = database_url
  end

  def self.project_name
    unless defined?(@@project_name) && @@project_name
      raise "You must call \"GojiLabs.project_name = 'PROJECT_NAME'\" before you try to use the variable functions"
    end
    @@project_name
  end

  def self.load_project
    unless [ENV_PRODUCTION, ENV_STAGING, ENV_TEST, ENV_DEVELOPMENT].include?(env)
      raise "Environment not set, you must set either GOJI_ENV, RAILS_ENV, or RACK_ENV to development, production, or staging."
    end

    unless development?
      require_relative 'goji_labs/initializers/airbrake'
      require_relative 'goji_labs/initializers/algolia'
    end

    require_relative 'goji_labs/monkey_patch/float'
    require_relative 'goji_labs/monkey_patch/nil_class'
    require_relative 'goji_labs/monkey_patch/string'
    require_relative 'goji_labs/monkey_patch/active_record/base'
  end
end
