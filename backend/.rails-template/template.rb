# frozen_string_literal: true

def source_paths
  [__dir__]
end

gem_group :development, :test do
  gem "factory_bot_rails"
  gem "rspec-rails", require: false
  gem "rubocop", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  gem "rubocop-rubycw", require: false
end

gem "bcrypt"
gem "graphql"

route 'post "/graphql", to: "graphql#execute"'

environment <<~'CODE'
  # For TZ
  config.time_zone = "Tokyo"
  # config.active_record.default_timezone = :local

  # For ActiveRecord query log tag
  config.active_record.query_log_tags_enabled = true
  config.active_record.query_log_tags = [
    # Rails query log tags:
    :application, :controller, :action, :job,
    # GraphQL-Ruby query log tags:
    current_graphql_operation: -> { GraphQL::Current.operation_name },
    current_graphql_field: -> { GraphQL::Current.field&.path },
    current_dataloader_source: -> { GraphQL::Current.dataloader_source_class },
  ]

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

%w[
  .gitattributes
  .gitignore
  .rubocop.yml
  app/controllers/concerns/authentication.rb
  app/controllers/graphql_controller.rb
  app/mailers/passwords_mailer.rb
  app/models/application_record.rb
  app/models/current.rb
  app/models/session.rb
  app/models/user.rb
  app/views/passwords_mailer/reset.html.erb
  app/views/passwords_mailer/reset.text.erb
  config/database.yml
  config/locales/en.yml
  compose.yaml
].each do
  copy_file _1
end

%w[
  app/graphql
  db/migrate
].each do
  directory _1
end
