# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module SourceGenerators
      class Base < ::Avm::SourceGenerators::Base
        module RootModule
          def root_module
            lib_path.camelize
          end

          # @return [String]
          def root_module_after_close
            s = root_module_requires.map { |e| "require '#{e}'\n" }.join
            s.present? ? "\n#{s}" : ''
          end

          def root_module_close
            root_module_components.count.times.map do |index|
              "#{IDENT * index}end"
            end.reverse.join("\n")
          end

          def root_module_inner_identation
            IDENT * root_module_components.count
          end

          def root_module_open
            root_module_components.each_with_index.map do |component, index|
              "#{IDENT * index}module #{component}"
            end.join("\n")
          end

          def root_module_components
            root_module.split('::')
          end

          # @return [Enumerable<String>]
          def root_module_requires
            []
          end
        end
      end
    end
  end
end
