source "https://rubygems.org"

ruby file: ".ruby-version"

gem "rails", "~> 8.1.4"
gem "propshaft"
gem "mysql2", "~> 0.5"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "bootsnap", require: false
gem "thruster", require: false
gem "tzinfo-data", platforms: %i[ windows jruby ]

gem "devise"
gem "simple_calendar", "~> 3.1"
gem "rails-i18n", "~> 8.0"
gem "aws-sdk-s3", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "bundler-audit", require: false
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
