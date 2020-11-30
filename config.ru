# frozen_string_literal: true

require "./app"

set :bind, "0.0.0.0"

run Sinatra::Application
