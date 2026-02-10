# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Sources
      class Base < ::Avm::EacGenericBase0::Sources::Base
        module Update
          def on_sub_updated
            update_self_content
          end

          # @return [String]
          def update_self_commit_message
            i18n_translate(
              __method__,
              gemfile_lock_path: gemfile_lock_path.relative_path_from(path)
            )
          end

          def update_self_content
            bundle_update.execute!
          rescue ::EacRubyUtils::Envs::ExecutionError
            raise ::Avm::Sources::UpdateError
          end
        end
      end
    end
  end
end
