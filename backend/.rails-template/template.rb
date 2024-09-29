# frozen_string_literal: true

def source_paths
  [__dir__]
end

gem_group :development, :test do
  gem 'rspec-rails', require: false
  gem 'factory_bot_rails'
  gem 'rubocop', require: false
  gem 'rubocop-rubycw', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

environment <<~'CODE'
  # For TZ
  config.time_zone = 'Tokyo'
  # config.active_record.default_timezone = :local

  # For ActiveRecord query log tag
  config.active_record.query_log_tags_enabled = true

  # For generator
  config.generators do |g|
    g.assets false
    g.helper false
    g.test_framework :rspec,
      fixtures:         true,
      view_specs:       false,
      helper_specs:     false,
      routing_specs:    false,
      controller_specs: false,
      request_specs:    false
    g.fixture_replacement :factory_bot, dir: 'spec/factories'
    g.after_generate do |files|
      files = files.reject { _1.end_with?('.erb') }
      system('bin/rubocop --autocorrect-all ' + files.join(' '), exception: true)
    end
  end
CODE

%w[
  .rubocop.yml
  app/models/application_record.rb
  compose.yaml
].each do
  copy_file _1
end
