# frozen_string_literal: true

require 'rails_helper'

module AirtableSync
  RSpec.describe AirtableSync::DestroyRecordJob do
    let(:article) { create(:article) }
    let(:mock_airtable_api) { instance_double(AirtableSync::Api, delete_record: nil) }
    let(:airtable_base_id) { ENV.fetch('AIRTABLE_BASE_ID') }

    context 'when airtable_id is nil' do
      it 'does not sync' do
        allow(AirtableSync::Api).to receive(:new).and_return(mock_airtable_api)

        AirtableSync::DestroyRecordJob.perform_now(table_name: 'articles', airtable_base_id:, airtable_id: nil)

        expect(mock_airtable_api).not_to have_received(:delete_record)
      end
    end

    context 'when airtable_base_id is nil' do
      it 'does not sync' do
        allow(AirtableSync::Api).to receive(:new).and_return(mock_airtable_api)

        AirtableSync::DestroyRecordJob.perform_now(table_name: 'articles', airtable_base_id: nil, airtable_id: 'airtable_id')

        expect(mock_airtable_api).not_to have_received(:delete_record)
      end
    end

    context 'when airtable_base_id is set' do
      it 'destroys record on Airtable', vcr: { cassette_name: 'delete_record' } do
        AirtableSync::Api.new(airtable_base_id).create_record(article, 'Articles')

        result = AirtableSync::DestroyRecordJob.perform_now(table_name: 'articles', airtable_base_id:, airtable_id: article.airtable_id)
        expect(result).to be true
      end
    end
  end
end
