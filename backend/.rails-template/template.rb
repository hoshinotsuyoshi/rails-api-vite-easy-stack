# frozen_string_literal: true

def source_paths
  [__dir__]
end

gem_group :development, :test do
  gem "rspec-rails", require: false
  gem "factory_bot_rails"
  gem "rubocop", require: false
  gem "rubocop-rubycw", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
end

gem "bcrypt"
gem "graphql"

environment <<~'CODE'
  # For TZ
  config.time_zone = "Tokyo"
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
    g.fixture_replacement :factory_bot, dir: "spec/factories"
    g.after_generate do |files|
      files = files.reject { _1.end_with?(".erb") }
      system("bin/rubocop --autocorrect-all " + files.join(" "), exception: true)
    end
  end
CODE

run 'mkdir -p db/migrate'

%w[
  .gitattributes
  .gitignore
  .rubocop.yml
  app/controllers/concerns/authentication.rb
  app/mailers/passwords_mailer.rb
  app/models/application_record.rb
  app/models/current.rb
  app/models/session.rb
  app/models/user.rb
  app/views/passwords_mailer/reset.html.erb
  app/views/passwords_mailer/reset.text.erb
  config/database.yml
  compose.yaml
  db/migrate/00000000000001_create_users.rb
  db/migrate/00000000000002_create_sessions.rb
].each do
  copy_file _1
end
