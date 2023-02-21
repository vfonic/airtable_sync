# frozen_string_literal: true

class Article < ApplicationRecord
  include AirtableSync::RecordSync

  def as_airtable_json
    {
      Title: self.title,
      Description: self.description,
      'Published at': self.published_at,
    }
  end
end
