# frozen_string_literal: true

# Synchronizes any changes to public records to AirTable
module AirtableSync
  module Callbacks
    extend ActiveSupport::Concern

    included do
      attr_accessor :skip_airtable_sync

      after_commit :create_airtable_record, on: :create
      after_commit :update_airtable_record, on: :update
      after_commit :destroy_airtable_record, on: :destroy

      def create_airtable_record
        return if should_skip_sync?

        AirtableSync::CreateRecordJob.perform_later(self.model_name.collection, self.id)
      end

      def update_airtable_record
        return if should_skip_sync?

        AirtableSync::UpdateRecordJob.perform_later(self.model_name.collection, self.id)
      end

      def destroy_airtable_record
        return if should_skip_sync?

        # Make sure table name is in the plural form
        table_name = self.model_name.collection.underscore.humanize

        AirtableSync::DestroyRecordJob.perform_later(table_name:, airtable_base_id:, airtable_id:)
      end

      private

        def should_skip_sync? = AirtableSync.configuration.skip_airtable_sync || self.skip_airtable_sync || self.airtable_base_id.blank?
    end
  end
end
