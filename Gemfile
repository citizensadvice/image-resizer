# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.2"

gem "image_processing"
gem "rake"
gem "sinatra"

group :development, :test do
  gem "byebug"
  gem "capybara"
  gem "citizens-advice-style", github: "citizensadvice/citizens-advice-style-ruby", tag: "v0.4.0"
  gem "rack-test"
  gem "rspec"
  gem "rubocop"
  gem "webmock"
end
