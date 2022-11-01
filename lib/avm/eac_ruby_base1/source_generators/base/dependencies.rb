# frozen_string_literal: true

require 'avm/eac_ruby_base1/source_generators/base/version_builder'
require 'avm/source_generators/base'
require 'eac_ruby_utils/core_ext'

module Avm
  module EacRubyBase1
    module SourceGenerators
      class Base < ::Avm::SourceGenerators::Base
        module Dependencies
          def eac_ruby_gem_support_version
            dependency_version('eac_ruby_gem_support')
          end

          def eac_ruby_utils_version
            dependency_version('eac_ruby_utils')
          end

          def dependency_version(gem_name)
            ::Avm::EacRubyBase1::SourceGenerators::Base::VersionBuilder.new(gem_name, options).to_s
          end
        end
      end
    end
  end
end
