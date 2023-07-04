# frozen_string_literal: true

module AirtableSync
  class Api
    attr_reader :base_id

    def initialize(base_id = nil)
      @base_id = base_id
    end

    def bases = JSON[Airrecord::Client.new(ENV.fetch('AIRTABLE_PERSONAL_ACCESS_TOKEN')).connection.get('/v0/meta/bases').body]['bases']
    def self.bases = new.bases

    def get_all_items(table_name:) = table(table_name).all

    def get_item(table_name, airtable_id) = table(table_name).find(airtable_id)

    def create_record(record, table_name)
      airtable_record = table(table_name).create(record.as_airtable_json) # rubocop:disable Rails/SaveBang
      record.update_column(:airtable_id, airtable_record.id) # rubocop:disable Rails/SkipsModelValidations
    end

    def update_record(record, table_name)
      airtable_record = table(table_name).find(record.airtable_id)
      record.as_airtable_json.each { |key, value| airtable_record[key.to_s] = value }
      airtable_record.save # rubocop:disable Rails/SaveBang
    end

    def delete_record(table_name, airtable_id) = table(table_name).find(airtable_id).destroy

    def table(table_name) = Airrecord.table(AirtableSync.configuration.api_key, base_id, table_name)
  end
end
