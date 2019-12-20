# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Middlewares::BasicAuthMiddleware do
  describe 'InstanceMethods' do
    describe '#call' do
      include Rack::Test::Methods

      def app
        Rack::Builder.new do
          use Middlewares::BasicAuthMiddleware
          run lambda { |_env| [200, {}, ['OK']] }
        end.to_app
      end

      context 'request with correct auth info' do
        subject(:response) do
          get('/', {}, auth_headers)
          last_response
        end

        let(:auth_headers) do
          {
            'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials('username', 'password')
          }
        end

        it 'authorize' do
          expect(response.status).to eq(200)
        end
      end

      context 'request with incorrect auth info' do
        subject(:response) do
          get('/', {}, auth_headers)
          last_response
        end

        let(:auth_headers) do
          {
            'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials('incorrect_username', 'incorrect_password')
          }
        end

        it 'unauthorize' do
          expect(response.status).to eq(401)
          expect(response.headers).to have_key("WWW-Authenticate")
          expect(response.headers["WWW-Authenticate"]).to match("Basic realm=")
          expect(response.body).to be_empty
        end
      end
    end
  end
end
