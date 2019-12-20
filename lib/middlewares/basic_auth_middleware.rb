# frozen_string_literal: true

module Middlewares
  class BasicAuthMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      Rack::Auth::Basic.new(@app) do |username, password|
        username == 'username' && password == 'password'
      end.call(env)
    end
  end
end
