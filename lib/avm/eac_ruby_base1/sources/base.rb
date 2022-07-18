# frozen_string_literal: true

require 'avm/eac_generic_base0/sources/base'
require 'avm/eac_ruby_base1/rubygems/version_file'
require 'avm/eac_ruby_base1/sources/update'
require 'avm/eac_ruby_base1/sources/runners/bundler'
require 'avm/version_number'
require 'eac_ruby_utils/core_ext'

module Avm
  module EacRubyBase1
    module Sources
      class Base < ::Avm::EacGenericBase0::Sources::Base
        RSPEC_TEST_COMMAND = 'rspec'

        require_sub __FILE__, include_modules: :prepend

        # @return [Hash<String, EacRubyUtils::Envs::Command>]
        def default_test_commands
          {
            RSPEC_TEST_COMMAND => rspec_test_command
          }
        end

        # To-do: dismiss this method at Avm::EacRailsBase1::Instance and remove.
        # @return [EacRubyUtils::Envs::BaseEnv]
        def env
          @env.presence || super
        end

        # To-do: dismiss this method at Avm::EacRailsBase1::Instance and remove.
        # @return [Avm::EacRubyBase1::Sources::Base]
        def env_set(env)
          @env = env

          self
        end

        # @return [EacRubyUtils::Envs::Command]
        def rspec_test_command
          bundle('exec', 'rspec', '--fail-fast').chdir_root
        end

        def valid?
          gemfile_path.exist? || gemspec_path.present?
        end

        def update
          ::Avm::EacRubyBase1::Sources::Update.new(self)
        end

        # @return [Avm::VersionNumber]
        def version
          version_file.value.if_present { |v| ::Avm::VersionNumber.new(v) }
        end

        def version=(value)
          version_file.value = value
        end

        # @return [Avm::EacRubyBase1::Rubygems::VersionFile]
        def version_file
          ::Avm::EacRubyBase1::Rubygems::VersionFile.new(version_file_path)
        end

        def version_file_path
          path.join('lib', *gem_namespace_parts, 'version.rb')
        end
      end
    end
  end
end
