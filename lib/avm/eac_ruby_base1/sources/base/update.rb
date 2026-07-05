# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Sources
      class Base < ::Avm::EacGenericBase0::Sources::Base
        module Update
          def on_sub_updated
            update_self
          end

          # @param changes [Enumerable<Avm::Sources::Change>]
          def update_self_changes_before_subs
            super + [
              ::Avm::EacRubyBase1::Sources::Update::Changes::BundleUpdate.new(self)
            ]
          end
        end
      end
    end
  end
end
