# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module LauncherStereotypes
      class Base
        class Publish < ::Avm::Launcher::Publish::Base
          include ::EacRubyUtils::SimpleCache
          enable_speaker

          private

          def publish
            gem_build.build
            push_gem
          ensure
            gem_build.close
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

          require_sub __FILE__, include_modules: true, require_mode: :kernel
        end
      end
    end
  end
end
