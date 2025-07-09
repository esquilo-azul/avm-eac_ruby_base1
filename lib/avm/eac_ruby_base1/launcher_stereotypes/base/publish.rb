# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module LauncherStereotypes
      class Base
        class Publish < ::Avm::Launcher::Publish::Base
          include ::EacRubyUtils::SimpleCache
          enable_speaker

          private

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

          require_sub __FILE__, require_mode: :kernel
        end
      end
    end
  end
end
