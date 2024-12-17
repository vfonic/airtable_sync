# 1.4.2

- Remove sprockets-rails as a gem dependency

# 1.4.1

- Bump actionpack from 7.0.4.3 to 7.0.5.1 (security release)

# 1.4.0

- Make public `AirtableSync::Api` instance method `#table(table_name)`

# 1.3.0

- Upgrade Airrecord dependency to '~> 1.0.12'
- Add AirtableSync::Api.bases which fetches all bases from Airtable

# 1.2.0

- Drop `airrecord` fork requirement
  My fix was merged into the original gem, so we can use the original gem again.
  My fix: https://github.com/sirupsen/airrecord/pull/100

# 1.1.0

- Use `airrecord` fork instead of the original gem
  This allows us to use the version of Airrecord with the fix for table names with spaces.

# 1.0.0

- Release initial version of the library
