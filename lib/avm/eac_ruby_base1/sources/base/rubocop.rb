# frozen_string_literal: true

require 'avm/eac_generic_base0/sources/base'
require 'avm/eac_ruby_base1/sources/base/bundle_command'
require 'avm/eac_ruby_base1/sources/bundle_update'
require 'eac_ruby_utils/core_ext'

module Avm
  module EacRubyBase1
    module Sources
      class Base < ::Avm::EacGenericBase0::Sources::Base
        module Rubocop
          RUBOCOP_CONFIG_SUBPATH = '.rubocop.yml'

          # @return [Avm::EacRubyBase1::Sources::Base::RubocopCommand]
          def rubocop_command
            ::Avm::EacRubyBase1::Sources::Base::RubocopCommand.new(self)
          end

          # @return [Pathname]
          def rubocop_config_path
            path.join(RUBOCOP_CONFIG_SUBPATH)
          end
        end
      end
    end
  end
end
