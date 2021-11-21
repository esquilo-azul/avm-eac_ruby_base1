# frozen_string_literal: true

require 'avm/source_stereotypes/base'
require 'avm/eac_ruby_base1/source_stereotypes/update'
require 'eac_ruby_gems_utils/gem'
require 'eac_ruby_utils/core_ext'

module Avm
  module EacRubyBase1
    module SourceStereotypes
      class Base < ::Avm::SourceStereotypes::Base
        delegate :gemspec_path, to: :the_gem

        def gemfile_path
          source.path.join('Gemfile')
        end

        def valid?
          gemfile_path.exist? || gemspec_file.exist?
        end

        # @return [EacRubyGemsUtils::Gem]
        def the_gem
          @the_gem ||= ::EacRubyGemsUtils::Gem.new(source.path)
        end

        def update_source(source)
          ::Avm::EacRubyBase1::SourceStereotypes::Update.new(source)
        end
      end
    end
  end
end
