# frozen_string_literal: true

require_relative 'lib/airtable_sync/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 3.1'
  spec.name        = 'airtable_sync'
  spec.version     = AirtableSync::VERSION
  spec.authors     = ['Viktor']
  spec.email       = ['viktor.fonic@gmail.com']
  spec.homepage    = 'https://github.com/vfonic/airtable_sync'
  spec.summary     = 'Keep Rails models in sync with AirTable.'
  spec.license     = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage

  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'rails', '>= 6.0'
  spec.add_dependency 'sprockets-rails'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
