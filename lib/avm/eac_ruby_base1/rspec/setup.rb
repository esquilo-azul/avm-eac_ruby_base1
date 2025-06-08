# frozen_string_literal: true

require 'avm/eac_ruby_base1/rspec/source_generator'

module Avm
  module EacRubyBase1
    module Rspec
      module Setup
        def self.extended(obj)
          obj.rspec_config.include(::Avm::EacRubyBase1::Rspec::SourceGenerator)
        end
      end
    end
  end
end
