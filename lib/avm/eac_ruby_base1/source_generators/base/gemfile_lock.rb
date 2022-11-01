# frozen_string_literal: true

require 'avm/eac_ruby_base1/source_generators/base/options'
require 'avm/source_generators/base'
require 'eac_ruby_utils/core_ext'

module Avm
  module EacRubyBase1
    module SourceGenerators
      class Base < ::Avm::SourceGenerators::Base
        module GemfileLock
          def generate_gemfile_lock
            return unless generate_gemfile_lock?

            self_gem.bundle('install').chdir_root.execute!
          end

          # @return [Boolean]
          def generate_gemfile_lock?
            options[::Avm::EacRubyBase1::SourceGenerators::Base::Options::GEMFILE_LOCK_OPTION]
              .to_bool
          end
        end
      end
    end
  end
end
