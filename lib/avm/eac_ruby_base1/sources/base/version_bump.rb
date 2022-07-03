# frozen_string_literal: true

require 'avm/eac_generic_base0/sources/base'
require 'eac_ruby_utils/core_ext'

module Avm
  module EacRubyBase1
    module Sources
      class Base < ::Avm::EacGenericBase0::Sources::Base
        module VersionBump
          def after_sub_version_bump_do_changes
            bundle('install').chdir_root.execute!
          end

          def version_bump_do_changes(target_version)
            self.version = target_version
            bundle('install').chdir_root.execute!
          end
        end
      end
    end
  end
end
