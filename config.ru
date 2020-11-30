# frozen_string_literal: true

require "./app"

set :bind, "0.0.0.0"
set :port, 4567

Sinatra::Application.run!
