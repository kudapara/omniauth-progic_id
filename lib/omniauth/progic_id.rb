require "omniauth/progic_id/version"
require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class ProgicId < OmniAuth::Strategies::OAuth2
      # change the class name and the :name option to match your application name
      option :name, :progic_id

      option :client_options, {
        :site => "http://localhost:5000",
        :authorize_url => "/oauth/authorize"
      }

      uid { raw_info["id"] }

      info do
        {
          :email => raw_info["email"],
          :name => raw_info["name"],
          :avatar_url => raw_info["avatar_url"]
          # and anything else you want to return to your API consumers
        }
      end

      extra do
        skip_info? ? {} : { :raw_info => raw_info }
      end

      def raw_info
        @raw_info ||= access_token.get('/api/v1/me.json').parsed
      end

      # https://github.com/intridea/omniauth-oauth2/issues/81
      def callback_url
        full_host + script_name + callback_path
      end
    end
  end
end
