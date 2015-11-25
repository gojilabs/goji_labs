require 'rails/all'  # Only a very little bit of this gem is actually needed
require_relative 'goji_labs/version'

module GojiLabs

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
    prefix = Rails.application.class.parent.name
    key = "#{prefix}_#{environment_variable.strip.split.join('_')}".underscore.upcase
    ENV[key]
  end

end

unless GojiLabs.development?
  require_relative 'goji_labs/initializers/airbrake'
  require_relative 'goji_labs/initializers/algolia'
end

require_relative 'goji_labs/monkey_patch/float'
require_relative 'goji_labs/monkey_patch/nil_class'
require_relative 'goji_labs/monkey_patch/string'
require_relative 'goji_labs/monkey_patch/active_record/base'
