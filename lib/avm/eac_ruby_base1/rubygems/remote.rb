# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Rubygems
      class Remote
        enable_simple_cache
        common_constructor :name

        # @return [Gem::Version, nil]
        def maximum_number
          numbers.max.if_present { |v| ::Gem::Version.new(v) }
        end

        # @return [Array<Gem::Version>]
        def numbers
          versions.map { |v| ::Gem::Version.new(v.fetch('number')) }
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
