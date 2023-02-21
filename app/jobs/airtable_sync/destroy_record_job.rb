# frozen_string_literal: true

module AirtableSync
  class DestroyRecordJob < ApplicationJob
    def perform(table_name:, airtable_base_id:, airtable_id:)
      return if airtable_base_id.blank?
      return if airtable_id.blank?

      AirtableSync::Api.new(airtable_base_id).delete_record(table_name, airtable_id)
    end
  end
end
