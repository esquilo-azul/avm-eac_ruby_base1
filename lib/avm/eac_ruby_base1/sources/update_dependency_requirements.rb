# frozen_string_literal: true

require 'avm/eac_ruby_base1/preferred_version_requirements'
require 'eac_ruby_utils/core_ext'

module Avm
  module EacRubyBase1
    module Sources
      class UpdateDependencyRequirements
        enable_simple_cache
        common_constructor :source, :gem_name

        def perform
          source.scm.commit_if_change(commit_message) { update_code }
        end

        private

        # @return [String]
        def commit_message
          i18n_translate(__method__,
                         name: gem_name,
                         requirements_list: requirements_list.join(', '),
                         __locale: source.locale)
        end

        # @return [Array<String>]
        def requirements_list_uncached
          ::Avm::EacRubyBase1::PreferredVersionRequirements.new(
            source.gemfile_lock_gem_version(gem_name)
          ).to_requirements_list
        end

        def gemspec_uncached
          ::Avm::EacRubyBase1::Rubygems::Gemspec.from_file(source.gemspec_path)
        end

        def update_code
          update_gemspec
          source.bundle.system!
        end

        def update_gemspec
          gemspec.dependency(gem_name).version_specs = requirements_list
          gemspec.write(source.gemspec_path)
          source.bundle('exec', 'rubocop', source.gemspec_path).system!
        end
      end
    end
  end
end