# frozen_string_literal: true

module AirtableSync
  class UpdateRecordJob < ApplicationJob
    # AirTable table name should be in plural form.
    # 'JobListing'.underscore.pluralize.humanize => 'Job listings'
    # 'job_listing'.underscore.pluralize.humanize => 'Job listings'
    def perform(model_name, id, table_name = model_name.underscore.pluralize.humanize)
      model_class = model_name.underscore.classify.constantize
      record = model_class.find_by(id:)
      return if record.blank?
      return if record.airtable_base_id.blank?
      return AirtableSync::CreateRecordJob.perform_now(model_name, id, table_name) if record.airtable_id.blank?

      AirtableSync::Api.new(record.airtable_base_id).update_record(record, table_name)
    end
  end
end
