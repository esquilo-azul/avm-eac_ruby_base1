# frozen_string_literal: true

require 'avm/eac_generic_base0/sources/base'
require 'eac_ruby_utils/core_ext'

module Avm
  module EacRubyBase1
    module Sources
      class Base < ::Avm::EacGenericBase0::Sources::Base
        module Bundler
          CONFIGURED_GEMFILE_PATH_ENTRY_KEY = 'ruby.gemfile_path'
          DEFAULT_GEMFILE_PATH = 'Gemfile'

          # @return [String]
          def configured_gemfile_path
            configuration.entry(CONFIGURED_GEMFILE_PATH_ENTRY_KEY).value
          end

          # @return [String]
          def default_gemfile_path
            DEFAULT_GEMFILE_PATH
          end

          # @return [Pathname]
          def gemfile_path
            path.join(configured_gemfile_path || default_gemfile_path)
          end
        end
      end
    end
  end
end
