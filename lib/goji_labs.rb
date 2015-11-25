require 'active_support'
require_relative 'goji_labs/version'

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
    raise "Project name must be set" if project_name.blank?
    ENV["#{project_name}_#{environment_variable.strip.split.join('_')}".underscore.upcase]
  end

  def self.project_name(name)
    @@project_name = name
  end

  def project_name
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
