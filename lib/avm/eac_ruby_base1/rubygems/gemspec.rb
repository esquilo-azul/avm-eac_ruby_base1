# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module Avm
  module EacRubyBase1
    module Rubygems
      class Gemspec
        require_sub __FILE__, require_dependency: true

        DEPENDENCY_LINE_PARSER = /s\.add_dependency\s*'(\S+)'/.to_parser { |m| m[1] }

        class << self
          def from_file(path)
            new(path.read.each_line.map(&:rstrip))
          end
        end

        common_constructor :lines

        # @param gem_name [String]
        # @return [Avm::EacRubyBase1::Bundler::Gemfile::Dependency]
        def dependency(gem_name)
          create_dependency(gem_name)
        end

        # @return [Array<Avm::EacRubyBase1::Bundler::Gemfile::Dependency>]
        def dependencies
          lines.lazy.map { |line| DEPENDENCY_LINE_PARSER.parse(line) }.compact_blank
            .map { |gem_name| dependency(gem_name) }.to_a
        end

        def write(path)
          path.to_pathname.write(to_text)
        end

        def to_text
          lines.map { |line| "#{line}\n" }.join
        end

        protected

        # @param gem_name [String]
        # @return [Avm::EacRubyBase1::Bundler::Gemfile::Dependency]
        def create_dependency(gem_name)
          ::Avm::EacRubyBase1::Rubygems::Gemspec::Dependency.new(self, gem_name)
        end
      end
    end
  end
end
