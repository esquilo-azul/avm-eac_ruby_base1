# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module Avm
  module EacRubyBase1
    module Sources
      class GemfileLocal
        class Sibling
          common_constructor :gemfile_local, :source
          delegate :relative_path, to: :source

          # @return [String]
          def target_content
            ["gem '#{source.gem_name}'", # rubocop:disable Style/StringConcatenation
             ["path: ::File.expand_path('",
              source.path.relative_path_from(gemfile_local.source.path).to_path,
              "', __dir__)"].join,
             'require: false'].join(', ') + "\n"
          end
        end
      end
    end
  end
end
