# frozen_string_literal: true

require 'avm/eac_ruby_base1/rubygems/gemspec'
require 'avm/eac_ruby_base1/sources/update_dependency_requirements'
require 'eac_cli/core_ext'

module Avm
  module EacRubyBase1
    module Sources
      module Runners
        class UpdateDependenciesRequirements
          runner_with :help, :subcommands do
            bool_opt '-a', '--all'
            pos_arg :gem_name, repeat: true, optional: true
          end

          def run
            runner_context.call(:source_banner)
            infov 'Gems to update', gem_names.count
            gem_names.each do |gem_name|
              infov 'Gem to update', gem_name
              ::Avm::EacRubyBase1::Sources::UpdateDependencyRequirements
                .new(runner_context.call(:source), gem_name).perform
            end
          end

          def gemspec
            ::Avm::EacRubyBase1::Rubygems::Gemspec.from_file(
              runner_context.call(:source).gemspec_path
            )
          end

          private

          def gem_names_uncached
            ::Set.new(parsed.gem_name + gem_names_from_all).sort
          end

          def gem_names_from_all
            return [] unless parsed.all?

            gemspec.dependencies.map(&:gem_name)
          end
        end
      end
    end
  end
end