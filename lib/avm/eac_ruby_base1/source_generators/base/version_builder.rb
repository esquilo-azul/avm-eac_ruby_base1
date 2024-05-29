# frozen_string_literal: true

require 'avm/source_generators/base'
require 'eac_ruby_utils/core_ext'

module Avm
  module EacRubyBase1
    module SourceGenerators
      class Base < ::Avm::SourceGenerators::Base
        class VersionBuilder
          enable_simple_cache
          common_constructor :gem_name, :options

          def to_s
            r = "'~> #{two_segments}'"
            r += ", '>= #{three_segments}'" if segments.count >= 3 && segments[2].positive?
            r
          end

          # @return [Gem::Version]
          def version
            options_version || loaded_version
          end

          def two_segments
            segments.first(2).join('.')
          end

          def three_segments
            segments.first(3).join('.')
          end

          private

          def segments_uncached
            version.release.to_s.split('.').map(&:to_i)
          end

          # @return [Gem::Version]
          def loaded_version
            ::Gem.loaded_specs[gem_name].version
          end

          def options_version
            options["#{gem_name}_version".dasherize.to_sym].if_present do |v|
              ::Gem::Version.new(v)
            end
          end
        end
      end
    end
  end
end
