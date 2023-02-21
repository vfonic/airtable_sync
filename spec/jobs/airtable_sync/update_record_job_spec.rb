# frozen_string_literal: true

require 'rails_helper'

module AirtableSync
  RSpec.describe AirtableSync::UpdateRecordJob do
    let(:model_name) { 'articles' }
    let(:article) { create(:article, airtable_id: 'recRMRQT6FvAgSbQW') }
    let(:mock_airtable_api) { instance_double(AirtableSync::Api, update_record: nil) }

    let(:airtable_base_id) { ENV.fetch('AIRTABLE_BASE_ID') }

    before(:each) do
      @old_airtable_site_id = AirtableSync.configuration.airtable_base_id
      AirtableSync.configure { |config| config.airtable_base_id = airtable_base_id }
    end

    after(:each) { AirtableSync.configure { |config| config.airtable_base_id = @old_airtable_site_id } }

    it 'updates record on Airtable', vcr: { cassette_name: 'update_record' } do
      article.update!(title: 'Updated article title')

      AirtableSync::UpdateRecordJob.perform_now(model_name, article.id)

      updated_article = AirtableSync::Api.new(airtable_base_id).get_item('articles', article.airtable_id)
      expect(updated_article['Title']).to eq 'Updated article title'
    end

    context 'when record does not exist' do
      let(:record_id) { 1_234_567 }

      it 'does not sync' do
        allow(AirtableSync::Api).to receive(:new).and_return(mock_airtable_api)

        AirtableSync::UpdateRecordJob.perform_now(model_name, record_id)

        expect(mock_airtable_api).not_to have_received(:update_record)
      end
    end

    context 'when airtable_base_id is nil' do
      let(:airtable_base_id) { nil }

      it 'does not sync' do
        allow(AirtableSync::Api).to receive(:new).and_return(mock_airtable_api)

        AirtableSync::UpdateRecordJob.perform_now(model_name, article.id)

        expect(mock_airtable_api).not_to have_received(:update_record)
      end
    end

    context 'when airtable_id is nil' do
      let(:mock_airtable_api) { instance_double(AirtableSync::Api, update_record: nil, create_record: nil) }

      before(:each) { article.update!(airtable_id: nil) }

      it 'calls CreateRecordJob' do
        allow(AirtableSync::Api).to receive(:new).and_return(mock_airtable_api)

        AirtableSync::UpdateRecordJob.perform_now(model_name, article.id)

        expect(mock_airtable_api).to have_received(:create_record)
      end
    end

    context 'when table name is passed' do
      let(:table_name) { 'Stories' }
      let(:article) { create(:article, airtable_id: 'recRMRQT6FvAgSbQW') }

      it 'updates record on AirTable', vcr: { cassette_name: 'update_sync_to_specified_table' } do
        article.update!(title: 'Updated article title')

        AirtableSync::UpdateRecordJob.perform_now(model_name, article.id, table_name)

        updated_article = AirtableSync::Api.new(airtable_base_id).get_item(table_name, article.airtable_id)
        expect(updated_article['Title']).to eq 'Updated article title'
      end
    end
  end
end
