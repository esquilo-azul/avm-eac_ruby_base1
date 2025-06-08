# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module LauncherStereotypes
      class Base
        class Publish < ::Avm::Launcher::Publish::Base
          include ::EacRubyUtils::SimpleCache
          enable_speaker

          protected

          def internal_check
            gem_published? ? internal_check_gem_published : internal_check_gem_unpublished
          end

          private

          def internal_check_gem_published
            if version_published?
              outdated_version? ? outdated_version_check_result : version_published_check_result
            else
              version_unpublished_check_result
            end
          end

          def internal_check_gem_unpublished
            if new_gem_allowed?
              version_unpublished_check_result
            else
              new_gem_disallowed_check_result
            end
          end

          def new_gem_disallowed_check_result
            ::Avm::Launcher::Publish::CheckResult.blocked(
              "#{gem_spec.full_name} does not exist in RubyGems"
            )
          end

          def version_published_check_result
            ::Avm::Launcher::Publish::CheckResult.updated("#{gem_spec.full_name} already pushed")
          end

          def outdated_version_check_result
            ::Avm::Launcher::Publish::CheckResult.outdated(
              "#{gem_spec.full_name} is outdated (Max: #{gem_version_max})"
            )
          end

          def version_unpublished_check_result
            ::Avm::Launcher::Publish::CheckResult.pending("#{gem_spec.full_name} not found " \
                                                          'in RubyGems')
          end

          def source_uncached
            instance.warped
          end

          def gem_spec_uncached
            ::Avm::EacRubyBase1::LauncherStereotypes::Base.load_gemspec(gemspec)
          end

          def gem_build_uncached
            ::Avm::EacRubyBase1::Launcher::Gem::Build.new(source)
          end

          def publish
            gem_build.build
            push_gem
          ensure
            gem_build.close
          end

          def new_gem_allowed?
            ::Avm::Launcher::Context.current.publish_options[:new]
          end

          def gem_published?
            gem_versions.any?
          end

          def version_published?
            gem_versions.any? { |v| v['number'] == gem_spec.version }
          end

          def outdated_version?
            gem_version_max.present? && ::Gem::Version.new(gem_spec.version) < gem_version_max
          end

          # @return [Array]
          def gem_versions
            remote_gem.versions
          end

          def gem_version_max
            remote_gem.maximum_number
          end

          # @return [Avm::EacRubyBase1::Rubygems::Remote]
          def remote_gem_uncached
            ::Avm::EacRubyBase1::Rubygems::Remote.new(gem_spec.name)
          end

          def push_gem
            info("Pushing gem #{gem_spec}...")
            command = ['gem', 'push', gem_build.output_file]
            unless ::Avm::Launcher::Context.current.publish_options[:confirm]
              command = %w[echo] + command + %w[(Dry-run)]
            end
            EacRubyUtils::Envs.local.command(command).system
            info('Pushed!')
          end

          def gemspec_uncached
            source.find_file_with_extension('.gemspec')
          end
        end
      end
    end
  end
end
