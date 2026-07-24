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

          # @return [void]
          def push_gem
            info("Pushing gem #{gem_spec}...")
            r = gem_provider.push_gem(gem_build.output_file)
            send(r.type == :success ? :success : :error, r.message)
          end

          require_sub __FILE__, include_modules: true, require_mode: :kernel
        end
      end
    end
  end
end
