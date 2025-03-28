# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_envs/http/request'

module Avm
  module EacRubyBase1
    module Rubygems
      module Providers
        class RubygemsOrg
          DEFAULT_ROOT_HTTP_URL = 'https://rubygems.org'.to_uri

          common_constructor :root_http_url, default: [DEFAULT_ROOT_HTTP_URL] do
            self.root_http_url = root_http_url.to_uri
          end

          # @return [Enumerable<String>]
          def gem_versions(gem_name)
            ::EacEnvs::Http::Request.new
              .url(root_http_url + "/api/v1/versions/#{gem_name}.json")
              .response.body_data_or_raise
          rescue EacEnvs::Http::Response => e
            e.status == 404 ? [] : raise(e)
          end
        end
      end
    end
  end
end
