# frozen_string_literal: true

module AirtableSync
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      def add_config_initializer
        template 'airtable_sync.rb', 'config/initializers/airtable_sync.rb'
      end
    end
  end
end
