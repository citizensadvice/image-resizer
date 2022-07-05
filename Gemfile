# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

gem "image_processing"
gem "puma"
gem "sinatra"
gem "sinatra-contrib", require: false

group :development, :test do
  gem "citizens-advice-style", github: "citizensadvice/citizens-advice-style-ruby", tag: "v9.0.0"
  gem "debug"
  gem "rack-test"
  gem "rspec"
end
