# frozen_string_literal: true

require 'rails_helper'

module AirtableSync
  RSpec.describe AirtableSync::InitialSyncJob do
    it 'assigns airtable_id to record', vcr: { cassette_name: 'initial_sync_job' } do
      article = create(:article)

      AirtableSync::InitialSyncJob.perform_now('articles')

      expect(article.reload.airtable_id).to eq('mock_item_id')
    end

    context 'when table does not exist', vcr: { cassette_name: 'initial_sync_job_no_table' } do
      it 'raises an error when it cannot find an AirTable table' do
        create(:article)
        error_message = "HTTP 404: TABLE_NOT_FOUND: Could not find table articles in application #{ENV.fetch('AIRTABLE_BASE_ID')}"

        expect { AirtableSync::InitialSyncJob.perform_now('articles') }.to raise_error(Airrecord::Error, error_message)
      end
    end
  end
end
