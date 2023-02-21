# frozen_string_literal: true

require 'rails_helper'

module AirtableSync
  RSpec.describe AirtableSync::CreateRecordJob do
    let(:model_name) { 'articles' }
    let(:article) { create(:article) }
    let(:mock_airtable_api) { instance_double(AirtableSync::Api, create_record: nil) }

    let(:airtable_base_id) { ENV.fetch('AIRTABLE_BASE_ID') }

    before(:each) do
      @old_airtable_site_id = AirtableSync.configuration.airtable_base_id

      AirtableSync.configure do |config|
        config.airtable_base_id = airtable_base_id
      end
    end

    after(:each) do
      AirtableSync.configure do |config|
        config.airtable_base_id = @old_airtable_site_id
      end
    end

    context 'when record does not exist' do
      let(:record_id) { 1_234_567 }

      it 'does not sync' do
        allow(AirtableSync::Api).to receive(:new).and_return(mock_airtable_api)

        AirtableSync::CreateRecordJob.perform_now(model_name, record_id)

        expect(mock_airtable_api).not_to have_received(:create_record)
      end
    end

    context 'when airtable_base_id is nil' do
      let(:airtable_base_id) { nil }

      it 'does not sync' do
        allow(AirtableSync::Api).to receive(:new).and_return(mock_airtable_api)

        AirtableSync::CreateRecordJob.perform_now(model_name, article.id)

        expect(mock_airtable_api).not_to have_received(:create_record)
      end
    end

    it 'creates record on Airtable', vcr: { cassette_name: 'create_record' } do
      AirtableSync::CreateRecordJob.perform_now(model_name, article.id)

      expect(article.reload.airtable_id).to be_present
    end

    context 'when table name is passed' do
      let(:table_name) { 'Blog Stories' }

      it 'creates record on AirTable', vcr: { cassette_name: 'create_sync_to_specified_table' } do
        AirtableSync::CreateRecordJob.perform_now(model_name, article.id, table_name)

        expect(article.reload.airtable_id).to be_present
      end

      it 'syncs with correct AirTable table', vcr: { cassette_name: 'create_check_specified_table' } do
        AirtableSync::CreateRecordJob.perform_now(model_name, article.id, table_name)

        last_added_record_in_airtable = AirtableSync::Api.new(article.airtable_base_id).get_all_items(table_name:).last

        expect(last_added_record_in_airtable['Title']).to eq article.title
      end
    end
  end
end
