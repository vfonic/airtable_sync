[![Build Status](https://github.com/vfonic/airtable_sync/workflows/build/badge.svg)](https://github.com/vfonic/airtable_sync/actions)

# AirtableSync

Keep your Ruby on Rails records in sync with AirTable.

Currently only one way Rails => AirTable synchronization.

For the latest changes, see the [CHANGELOG.md](CHANGELOG.md).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'airtable_sync'
```

And then execute:

```bash
$ bundle
```

Then run the install generator:

```bash
bundle exec rails generate airtable_sync:install
```

## Usage

1. Generate AirTable API key
   https://airtable.com/create/apikey
2.

### Configuration options

In `config/initializers/airtable_sync.rb` you can specify configuration options:

1. `api_key`
2. `webflow_site_id`
3. `skip_airtable_sync` - skip synchronization for different environments.

Example:

```rb
AirtableSync.configure do |config|
  config.api_key = ENV.fetch('AIRTABLE_API_KEY')
  config.skip_airtable_sync = ActiveModel::Type::Boolean.new.cast(ENV.fetch('SKIP_AIRTABLE_SYNC'))
end
```

### Add AirtableSync to models

For each model that you want to sync to AirTable, you need to run the connection generator:

```bash
bundle exec rails generate airtable_sync:connection Article
```

Please note that this _does not_ create the AirTable table. You need to already have it or create it manually.

### Create AirTable tables

As mentioned above, you need to create the AirTable tables yourself.

### Set `airtable_base_id`

There are couple of ways how you can set the `airtable_base_id` to be used.

#### Set `airtable_base_id` through configuration

In `config/initializers/airtable_sync.rb` you can specify `airtable_base_id`:

```ruby
AirtableSync.configure do |config|
  config.airtable_base_id = ENV.fetch('AIRTABLE_BASE_ID')
end
```

### Customize fields to synchronize

By default, AirtableSync calls `#as_airtable_json` on a record to get the fields that it needs to push to AirTable. `#as_airtable_json` simply calls `#as_json` in its default implementation. To change this behavior, you can override `#as_airtable_json` in your model:

```ruby
# app/models/article.rb
class Article < ApplicationRecord
  include AirtableSync::RecordSync

  def as_airtable_json
    {
      'Post Title': self.title.capitalize,
      'Short Description': self.title.parameterize,
      'Long Description': self.created_at,
    }
  end
end
```

### Sync a Rails model to different AirTable table

If AirTable table name does not match the Rails model collection name, you need to specify table name for each `CreateRecordJob`, `DestroyRecordJob`, and `UpdateRecordJob` call. If not specified, model collection name is used as the table name.
You also need to replace included `AirtableSync::RecordSync` with custom callbacks that will call appropriate AirtableSync jobs.

For example:

```ruby
AirtableSync::CreateRecordJob.perform_later(model_name, id, table_name)
AirtableSync::UpdateRecordJob.perform_later(model_name, id, table_name)
AirtableSync::DestroyRecordJob.perform_later(table_name:, airtable_id:)
```

Where:

1.  `model_name` - Rails model with `airtable_id` column
2.  `table_name` - AirTable table name (defaults to: `model_name.underscore.pluralize.humanize`)

For example:

```ruby
AirtableSync::CreateRecordJob.perform_now('articles', 1, 'Stories')
```

Or, if you want to use the default 'articles' table name:

```ruby
AirtableSync::CreateRecordJob.perform_now('articles', 1)
```

### Run the initial sync

After setting up which models you want to sync to AirTable, you can run the initial sync for each of the models:

```ruby
AirtableSync::InitialSyncJob.perform_later('articles')
```

You can also run this from a Rake task:

```ruby
bundle exec rails "airtable_sync:initial_sync[articles]"
```

Quotes are needed in order for this to work in all shells.

### Important note

This gem silently "fails" (does nothing) when `airtable_base_id` or `airtable_id` is `nil`! This is not always desired behavior so be aware of that.

## Contributing

PRs welcome!

To run RuboCop style check and RSpec tests run:

```sh
bundle exec rake
```

To run only RuboCop run:

```sh
bundle exec rails style
```

To run RSpec tests run:

```sh
bundle exec spec
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
