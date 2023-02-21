# frozen_string_literal: true

module AirtableSync
  class << self
    attr_reader :configuration

    def configure
      self.configuration ||= Configuration.new

      self.configuration.skip_airtable_sync = !Rails.env.production?

      yield(self.configuration)

      self.configuration.api_key ||= ENV.fetch('AIRTABLE_API_KEY')
    end

    private

      attr_writer :configuration
  end

  class Configuration
    attr_accessor :skip_airtable_sync, :airtable_base_id, :api_key
  end
end
