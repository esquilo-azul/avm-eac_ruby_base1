# frozen_string_literal: true

require 'avm/eac_generic_base0/sources/tester'
require 'eac_ruby_utils/core_ext'

module Avm
  module EacRubyBase1
    module Sources
      class Tester < ::Avm::EacGenericBase0::Sources::Tester
        BUNDLE_TEST_COMMAND_CONFIGURATION_KEY = :bundle_test_command

        # @return [Avm::EacRailsBase1::Sources::Base::BundleCommand, nil]
        def test_command
          bundle_test_command || super || default_test_command
        end

        # @return [Avm::EacRailsBase1::Sources::Base::BundleCommand, nil]
        def bundle_test_command
          source.read_configuration_as_shell_words(BUNDLE_TEST_COMMAND_CONFIGURATION_KEY)
            .if_present { |args| source.bundle(*args).chdir_root }
        end

        # @return [Avm::EacRailsBase1::Sources::Base::BundleCommand, nil]
        def default_test_command
          source.bundle('exec', 'rspec', '--fail-fast').chdir_root
        end

        def run_test_command
          execute_command_and_log(source.bundle('install').chdir_root) ||
            execute_command_and_log(source.bundle('update').chdir_root)
          super
        end
      end
    end
  end
end
