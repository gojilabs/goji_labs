module GojiLabs
  ENV_DEVELOPMENT = 'development'
  ENV_STAGING     = 'staging'
  ENV_PRODUCTION  = 'production'
  ENV_TEST        = 'test'

	def self.env
    ENV['GOJI_ENV'] || ENV['RAILS_ENV'] || ENV['RACK_ENV']
	end

  def self.project_name
    ENV['PROJECT_NAME']
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

  def self.load_project
    unless [ENV_PRODUCTION, ENV_STAGING, ENV_TEST, ENV_DEVELOPMENT].include?(env)
      raise "Environment not set, you must set either GOJI_ENV, RAILS_ENV, or RACK_ENV to development, production, or staging."
    end

    unless project_name && project_name.length > 0
      raise "PROJECT_NAME not set."
    end

    require_relative 'goji_labs/initializers/airbrake'
    require_relative 'goji_labs/initializers/algolia'
    require_relative 'goji_labs/monkey_patch/fixnum'
    require_relative 'goji_labs/monkey_patch/float'
    require_relative 'goji_labs/monkey_patch/nil_class'
    require_relative 'goji_labs/monkey_patch/string'
    require_relative 'goji_labs/monkey_patch/active_record/base'
  end

  require 'goji_labs/railtie' if defined?(Rails)
end
