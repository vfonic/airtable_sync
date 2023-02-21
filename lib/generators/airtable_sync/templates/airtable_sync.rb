# frozen_string_literal: true

AirtableSync.configure do |config|
  # config.api_key = ENV.fetch('AIRTABLE_API_KEY')
  # config.skip_airtable_sync = !Rails.env.production?
  config.airtable_base_id = ENV.fetch('AIRTABLE_BASE_ID')
end
