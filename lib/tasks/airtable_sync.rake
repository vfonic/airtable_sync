# frozen_string_literal: true

namespace :airtable_sync do
  desc 'Perform initial sync from Rails to AirTable'
  task :initial_sync, %i[table_name] => :environment do |_task, args|
    AirtableSync::InitialSyncJob.perform_later(args[:table_name])
  end
end
