# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module Avm
  module EacRubyBase1
    module Rubygems
      class Gemspec
        class Dependency
          common_constructor :gemspec, :gem_name

          def version_specs=(version_specs)
            gemspec.add_or_replace_gem_line(gem_name, version_specs)
          end
        end
      end
    end
  end
end
