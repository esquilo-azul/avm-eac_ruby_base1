# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Sources
      module Update
        module Changes
          class UpdateRequirements < ::Avm::Sources::Change
            enable_memoized

            # @return [void]
            def perform
              source.bundle.system!
              update_gemspec
              source.bundle.system!
            end

            RUBOCOP_OK_CODES = [256].freeze

            protected

            # @param dependency [Avm::EacRubyBase1::Rubygems::Gemspec::Dependency]
            # @return [Array<String>]
            def dependency_requirements_list(dependency)
              ::Avm::EacRubyBase1::PreferredVersionRequirements.new(
                source.gemfile_lock_gem_version(dependency.gem_name)
              ).to_requirements_list
            end

            # @return [String]
            def format_gemspec
              source.rubocop_command.ignore_parent_exclusion(true).autocorrect(true)
                .file(source.gemspec_path)
                .execute!(exit_outputs: RUBOCOP_OK_CODES.index_with { |_k| nil })
            end

            # @return [Avm::EacRubyBase1::Rubygems::Gemspec]
            memoize def gemspec
              ::Avm::EacRubyBase1::Rubygems::Gemspec.from_file(source.gemspec_path)
            end

            # @return [String]
            def update_gemspec
              gemspec.dependencies.each do |dependency|
                dependency.version_specs = dependency_requirements_list(dependency)
              end
              gemspec.write(source.gemspec_path)
              format_gemspec
            end
          end
        end
      end
    end
  end
end
