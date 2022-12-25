# frozen_string_literal: true

require 'avm/eac_generic_base0/sources/base'
require 'eac_ruby_utils/core_ext'

module Avm
  module EacRubyBase1
    module Sources
      class Base < ::Avm::EacGenericBase0::Sources::Base
        module Update
          def on_sub_updated
            update_self_content
          end

          def update_self_content
            bundle_update.execute!
          end
        end
      end
    end
  end
end
