require 'rails/all'
require "goji_labs/version"

module GojiLabs

  ENVIRONMENT_PREFIX = Rails.application.class.parent.name.underscore.upcase

	def self.env
		if Rails.env.production?
			ENV['GOJI_ENV']
		else
			Rails.env
		end
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
    ENV["#{ENVIRONMENT_PREFIX}_#{environment_variable.strip.underscore.upcase}"]
  end

end
