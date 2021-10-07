# frozen_string_literal: true

require 'avm/eac_ruby_base1/source_stereotypes/base'

::RSpec.describe ::Avm::EacRubyBase1::SourceStereotypes::Base do
  include_examples 'in_avm_registry', 'source_stereotypes'
end
