# frozen_string_literal: true

require 'bundler/setup'

APP_RAKEFILE = File.expand_path('spec/dummy/Rakefile', __dir__)
load 'rails/tasks/engine.rake'

load 'rails/tasks/statistics.rake'

require 'bundler/gem_tasks'

require 'stylecheck/rake_tasks' unless Rails.env.production?

load 'rspec/rails/tasks/rspec.rake'
task :default do
  Rake::Task['style:rubocop:run'].execute
  Rake::Task['spec'].execute
end
