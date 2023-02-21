# frozen_string_literal: true

# Synchronizes any changes to public records to AirTable
module AirtableSync
  module RecordSync
    extend ActiveSupport::Concern

    included do
      include AirtableSync::Callbacks

      # override this method to get more granular, per site customization
      # for example, you could have Site model in your codebase:
      #
      # class Site < ApplicationRecord
      #   has_many :articles
      # end
      #
      # class Article < ApplicationRecord
      #   belongs_to :site
      #
      #   def airtable_base_id
      #     self.site.airtable_base_id
      #   end
      # end
      #
      def airtable_base_id = AirtableSync.configuration.airtable_base_id

      # You can customize this to your liking:
      # def as_airtable_json
      #   {
      #     title: self.title.capitalize,
      #     slug: self.title.parameterize,
      #     published_at: self.created_at,
      #     image: self.image_url
      #   }
      # end
      def as_airtable_json = self.as_json
    end
  end
end
