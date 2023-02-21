# frozen_string_literal: true

module AirtableSync
  class InitialSyncJob < ApplicationJob
    def perform(table_name)
      model_class = table_name.underscore.classify.constantize
      model_class.where(airtable_id: nil).find_each do |record|
        next if record.airtable_base_id.blank?

        client(record.airtable_base_id).create_record(record, table_name)
      end
    end

    private

      def client(site_id)
        if @client&.site_id == site_id
          @client
        else
          @client = AirtableSync::Api.new(site_id)
        end
      end
  end
end
