# frozen_string_literal: true

require 'avm/eac_generic_base0/sources/base'
require 'eac_ruby_utils/core_ext'

module Avm
  module EacRubyBase1
    module Sources
      class Base < ::Avm::EacGenericBase0::Sources::Base
        module Bundler
          DEFAULT_GEMFILE_PATH = 'Gemfile'

          # @return [String]
          def default_gemfile_path
            DEFAULT_GEMFILE_PATH
          end

          # @return [Pathname]
          def gemfile_path
            path.join(default_gemfile_path)
          end
        end
      end
    end
  end
end
