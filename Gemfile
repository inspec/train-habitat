# frozen_string_literal: true

source "https://rubygems.org"

gem "train-core", [">= 1.7.5", "< 4.0"]

if Gem.ruby_version.to_s.start_with?("2.5")
  # 16.7.23 required ruby 2.6+
  gem "chef-utils", "< 16.7.23" # TODO: remove when we drop ruby 2.5
end

gemspec

group :development do
  gem "byebug", "~> 11.0"
  gem "m", "~> 1.5"
  gem "minitest", "~> 5.11"
  gem "mocha", "~> 1.8"
  gem "pry", "~> 0.11"
  gem "rake", "~> 13.0"
  gem "chefstyle", "2.1.1"
end
