# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_envs/http/request'

module Avm
  module EacRubyBase1
    module Rubygems
      class Remote
        enable_simple_cache
        common_constructor :name

        # @return [String]
        def maximum_number
          numbers.max
        end

        # @return [Array<String>]
        def numbers
          versions.map { |v| v.fetch('number') }
        end

        protected

        # @return [Array<Hash>]
        def versions_uncached
          ::EacEnvs::Http::Request.new
            .url("https://rubygems.org/api/v1/versions/#{name}.json")
            .response.body_data_or_raise
        rescue EacEnvs::Http::Response => e
          e.status == 404 ? [] : raise(e)
        end
      end
    end
  end
end
