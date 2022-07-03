# frozen_string_literal: true

require 'avm/eac_ruby_base1/sources/tests/base'

module Avm
  module EacRubyBase1
    module Sources
      module Tests
        class Rspec < ::Avm::EacRubyBase1::Sources::Tests::Base
          def bundle_exec_args
            %w[rspec]
          end

          def dependency_gem
            'rspec-core'
          end

          def test_directory
            'spec'
          end
        end
      end
    end
  end
end
