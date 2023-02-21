# frozen_string_literal: true

require 'rails/generators/active_record'

module AirtableSync
  module Generators
    class ConnectionGenerator < Rails::Generators::NamedBase
      desc 'Registers ActiveRecord model to sync to AirTable table'

      source_root File.expand_path('templates', __dir__)

      include Rails::Generators::Migration
      def add_migration
        migration_template 'migration.rb.erb', "#{migration_path}/add_airtable_id_to_#{table_name}.rb",
                           migration_version:
      end

      def include_record_sync_in_model_file
        module_snippet = <<~END_OF_INCLUDE.indent(2)

          include AirtableSync::RecordSync
        END_OF_INCLUDE

        insert_into_file "app/models/#{name.underscore}.rb", module_snippet, after: / < ApplicationRecord$/
      end

      def self.next_migration_number(dirname) = ActiveRecord::Generators::Base.next_migration_number(dirname)

      private

        def migration_path = ActiveRecord::Migrator.migrations_paths.first

        def migration_version = "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
    end
  end
end
