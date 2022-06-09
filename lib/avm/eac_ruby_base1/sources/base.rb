# frozen_string_literal: true

require 'avm/eac_generic_base0/sources/base'
require 'avm/eac_ruby_base1/sources/update'
require 'avm/eac_ruby_base1/sources/tester'
require 'avm/version_number'
require 'eac_ruby_gems_utils/gem'
require 'eac_ruby_utils/core_ext'

module Avm
  module EacRubyBase1
    module Sources
      class Base < ::Avm::EacGenericBase0::Sources::Base
        require_sub __FILE__, include_modules: :prepend, require_dependency: true
        delegate :gemspec_path, to: :the_gem

        def gemfile_path
          path.join('Gemfile')
        end

        def valid?
          gemfile_path.exist? || gemspec_path.present?
        end

        # @return [Avm::EacRubyBase1::Sources::Tester]
        def tester_class
          Avm::EacRubyBase1::Sources::Tester
        end

        # @return [EacRubyGemsUtils::Gem]
        def the_gem
          @the_gem ||= ::EacRubyGemsUtils::Gem.new(path)
        end

        def update
          ::Avm::EacRubyBase1::Sources::Update.new(self)
        end

        # @return [Avm::VersionNumber]
        def version
          the_gem.version.if_present { |v| ::Avm::VersionNumber.new(v) }
        end

        def version=(value)
          the_gem.version_file.value = value
        end
      end
    end
  end
end
