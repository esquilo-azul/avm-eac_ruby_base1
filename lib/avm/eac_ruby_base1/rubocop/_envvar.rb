# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module Avm
  module EacRubyBase1
    class Rubocop
      RUBOCOP_COMMAND_ENVVAR_NAME = 'RUBOCOP_COMMAND'

      def env_rubocop_command
        ENV[RUBOCOP_COMMAND_ENVVAR_NAME].present? ? cmd(ENV[RUBOCOP_COMMAND_ENVVAR_NAME]) : nil
      end
    end
  end
end
