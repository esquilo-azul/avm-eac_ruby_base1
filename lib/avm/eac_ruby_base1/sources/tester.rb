# frozen_string_literal: true

require 'avm/source_stereotypes/tester'
require 'eac_ruby_utils/core_ext'

module Avm
  module EacRubyBase1
    module Sources
      class Tester < ::Avm::SourceStereotypes::Tester
        BUNDLE_TEST_COMMAND_CONFIGURATION_KEY = :bundle_test_command

        delegate :the_gem, to: :source_stereotype

        # @return [EacRubyUtils::Envs::Command, nil]
        def test_command
          bundle_test_command || super || default_test_command
        end

        # @return [EacRubyGemsUtils::Gem::Command, nil]
        def bundle_test_command
          source.read_configuration_as_shell_words(BUNDLE_TEST_COMMAND_CONFIGURATION_KEY)
                .if_present { |args| the_gem.bundle(*args).chdir_root }
        end

        # @return [EacRubyGemsUtils::Gem::Command, nil]
        def default_test_command
          the_gem.bundle('exec', 'rspec', '--fail-fast').chdir_root
        end

        def run_test_command
          execute_command_and_log(the_gem.bundle('install').chdir_root)
          super
        end
      end
    end
  end
end
