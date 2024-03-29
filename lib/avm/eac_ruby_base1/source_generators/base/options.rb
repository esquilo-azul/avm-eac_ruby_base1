# frozen_string_literal: true

require 'avm/source_generators/base'
require 'eac_ruby_utils/core_ext'

module Avm
  module EacRubyBase1
    module SourceGenerators
      class Base < ::Avm::SourceGenerators::Base
        module Options
          common_concern

          GEMFILE_LOCK_OPTION = :'gemfile-lock'

          OPTIONS = {
            :'eac-ruby-utils-version' => 'Version for "eac_ruby_utils" gem.',
            :'eac-ruby-gem-support-version' => 'Version for "eac_ruby_gem_support" gem.',
            GEMFILE_LOCK_OPTION => 'Run "bundle install" at the end'
          }.freeze

          module ClassMethods
            def option_list
              OPTIONS.inject(super) { |a, e| a.option(*e) }
            end
          end
        end
      end
    end
  end
end
