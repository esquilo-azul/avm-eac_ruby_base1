# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Sources
      module Update
        module Changes
          class BundleUpdate < ::Avm::Sources::Change
            # @return [String]
            def commit_message
              i18n_translate(
                __method__,
                gemfile_lock_path: source.gemfile_lock_path.relative_path_from(source.path)
              )
            end

            # @return [void]
            def perform
              source.bundle_update.execute!
            rescue ::EacRubyUtils::Envs::ExecutionError
              raise ::Avm::Sources::UpdateError
            end
          end
        end
      end
    end
  end
end
