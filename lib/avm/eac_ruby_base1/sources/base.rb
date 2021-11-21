# frozen_string_literal: true

require 'avm/source_stereotypes/base'
require 'avm/eac_ruby_base1/sources/update'
require 'avm/eac_ruby_base1/sources/tester'
require 'eac_ruby_gems_utils/gem'
require 'eac_ruby_utils/core_ext'

module Avm
  module EacRubyBase1
    module Sources
      class Base < ::Avm::SourceStereotypes::Base
        delegate :gemspec_path, to: :the_gem

        def gemfile_path
          source.path.join('Gemfile')
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
          @the_gem ||= ::EacRubyGemsUtils::Gem.new(source.path)
        end

        def update_source(source)
          ::Avm::EacRubyBase1::Sources::Update.new(source)
        end
      end
    end
  end
end
