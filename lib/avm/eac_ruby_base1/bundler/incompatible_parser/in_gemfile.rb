# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'avm/eac_ruby_base1/bundler/incompatible_parser/line_parser_base'

module Avm
  module EacRubyBase1
    module Bundler
      class IncompatibleParser
        class InGemfile < ::Avm::EacRubyBase1::Bundler::IncompatibleParser::LineParserBase
          LINE_PARSER = /In Gemfile:/
                          .to_parser { |_m| new }
        end
      end
    end
  end
end
