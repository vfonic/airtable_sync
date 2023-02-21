# frozen_string_literal: true

require 'rails_helper'

module AirtableSync
  RSpec.describe Configuration do
    context 'when skip_airtable_sync is false' do
      it 'is false' do
        AirtableSync.configure do |config|
          config.skip_airtable_sync = false
        end

        expect(AirtableSync.configuration.skip_airtable_sync).to be(false)
      end
    end

    context 'when skip_airtable_sync is true' do
      it 'is true' do
        AirtableSync.configure do |config|
          config.skip_airtable_sync = true
        end

        expect(AirtableSync.configuration.skip_airtable_sync).to be(true)
      end
    end
  end
end
