# frozen_string_literal: true

require 'avm/eac_ruby_base1/sources/base'

::RSpec.describe ::Avm::EacRubyBase1::Sources::Base do
  include_examples 'in_avm_registry', 'sources'
end
