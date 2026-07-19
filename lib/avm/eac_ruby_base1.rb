# frozen_string_literal: true

require 'eac_ruby_base1'
EacRubyBase1::RootModuleSetup.perform __FILE__ do
  require 'aranha/parsers'
  require 'avm'
  require 'avm/eac_generic_base0'
  require 'eac_templates'
  require 'eac_envs/http'
end
