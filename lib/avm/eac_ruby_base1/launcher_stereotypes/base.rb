# frozen_string_literal: true

require 'avm/launcher/stereotype'
require 'avm/eac_ruby_base1/launcher/gem/specification'
require 'eac_ruby_utils/core_ext'

module Avm
  module EacRubyBase1
    module LauncherStereotypes
      class Base
        require_sub __FILE__
        include ::Avm::Launcher::Stereotype

        class << self
          def match?(path)
            Dir.glob(File.join(path.real, '*.gemspec')).any?
          end

          def color
            :red
          end

          def load_gemspec(gemspec_file)
            ::Avm::EacRubyBase1::Launcher::Gem::Specification.new(gemspec_file)
          end
        end
      end
    end
  end
end
