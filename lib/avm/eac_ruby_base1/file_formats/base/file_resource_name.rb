# frozen_string_literal: true

require 'avm/eac_generic_base0/file_formats/base'
require 'avm/eac_ruby_base1/rubocop'

module Avm
  module EacRubyBase1
    module FileFormats
      class Base < ::Avm::EacGenericBase0::FileFormats::Base
        class FileResourceName
          enable_method_class
          common_constructor :file_format, :path do
            self.path = path.to_pathname
          end

          LIBRARY_PATTERNS = [%r{lib/((?!.*/lib/).+)\.rb\z},
                              %r{app/[^/]+/(.+)\.rb\z}].freeze

          # @param path [Pathname]
          # @return [Avm::FileFormats::FileWith]
          def result
            result_from_library || result_from_superclass
          end

          private

          def result_from_library
            result_from_patterns(LIBRARY_PATTERNS) { |m| m[1].camelize }
          end

          def result_from_patterns(patterns)
            patterns.lazy.map { |pattern| pattern.to_parser.parse(path.to_path) }
              .find(&:present?).if_present { |v| yield(v) }
          end

          def result_from_superclass
            file_format.class.superclass.instance_method(:file_resource_name)
              .bind_call(file_format, path)
          end
        end
      end
    end
  end
end
