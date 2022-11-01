# frozen_string_literal: true

require 'avm/source_generators/base'
require 'eac_ruby_utils/core_ext'

module Avm
  module EacRubyBase1
    module SourceGenerators
      class Base < ::Avm::SourceGenerators::Base
        module GemfileLock
          def generate_gemfile_lock
            self_gem.bundle('install').chdir_root.execute!
          end
        end
      end
    end
  end
end
