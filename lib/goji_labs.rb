module GojiLabs

	def self.env
    ENV['GOJI_ENV'] || ENV['RAILS_ENV'] || ENV['RACK_ENV']
	end

	def self.development?
		env == 'development'
	end

	def self.production?
		env == 'production'
	end

	def self.staging?
		env == 'staging'
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
    puts "[GojiLabs] Setting DATABASE_URL to #{database_url}"
    ENV['DATABASE_URL'] = database_url
  end

  def self.project_name
    unless defined?(@@project_name) && @@project_name
      raise "You must call \"GojiLabs.project_name = 'PROJECT_NAME'\" before you try to use the variable functions"
    end
    @@project_name
  end
end


unless GojiLabs.development? || GojiLabs.production? || GojiLabs.staging?
  raise "Environment not set, you must set either GOJI_ENV, RAILS_ENV, or RACK_ENV to development, production, or staging."
end

unless GojiLabs.development?
  require_relative 'goji_labs/initializers/airbrake'
  require_relative 'goji_labs/initializers/algolia'
end

require_relative 'goji_labs/monkey_patch/float'
require_relative 'goji_labs/monkey_patch/nil_class'
require_relative 'goji_labs/monkey_patch/string'
require_relative 'goji_labs/monkey_patch/active_record/base'
