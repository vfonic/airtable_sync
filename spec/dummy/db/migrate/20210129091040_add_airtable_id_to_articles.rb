# frozen_string_literal: true

class AddAirtableIdToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :airtable_id, :string
  end
end
