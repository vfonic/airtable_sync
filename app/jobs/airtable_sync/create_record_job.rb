# frozen_string_literal: true

module AirtableSync
  class CreateRecordJob < ApplicationJob
    # AirTable table name should be in plural form.
    # 'JobListing'.underscore.pluralize.humanize => "Job listings"
    # 'job_listing'.underscore.pluralize.humanize => "Job listings"
    # We can sync Rails model that has different class name than its AirTable table name
    # model_name => Rails model that has airtable_id column
    # table_name => AirTable table name
    # model_name = 'Article'; id = article.id, table_name = 'Posts'
    def perform(model_name, id, table_name = model_name.underscore.pluralize.humanize)
      model_class = model_name.underscore.classify.constantize
      record = model_class.find_by(id:)
      return if record.blank?
      return if record.airtable_base_id.blank?

      AirtableSync::Api.new(record.airtable_base_id).create_record(record, table_name)
    end
  end
end
