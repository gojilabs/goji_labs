require 'rails/all'  # Only a very little bit of this gem is actually needed

require_relative 'goji_labs/monkey_patch/fixnum'
require_relative 'goji_labs/monkey_patch/float'
require_relative 'goji_labs/monkey_patch/nil_class'
require_relative 'goji_labs/monkey_patch/string'
require_relative 'goji_labs/version'

module GojiLabs

  ENVIRONMENT_PREFIX = Rails.application.class.parent.name.underscore.upcase

	def self.env
		if Rails.env.production?
			ENV['GOJI_ENV'] || 'production'
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
