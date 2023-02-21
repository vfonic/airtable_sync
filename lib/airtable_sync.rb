# frozen_string_literal: true

require 'airtable_sync/version'
require 'airtable_sync/configuration'
require 'airtable_sync/engine'
require 'airrecord'

module AirtableSync
end

module Airrecord
  class Client
    def escape(*args) = ERB::Util.url_encode(*args)
  end
end
