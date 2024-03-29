# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module Avm
  module EacRubyBase1
    module Rubygems
      class Gemspec
        class AddOrReplaceGemLine
          enable_method_class
          common_constructor :sender, :gem_name, :gem_specs
          delegate :lines, to: :sender

          DEPENDENCY_PREFIX = '  s.add_dependency'

          def existing_gem_line_index
            lines.index { |line| line.start_with?(gem_line_prefix) }
          end

          def result
            if existing_gem_line_index.present?
              replace_line
            else
              add_line
            end
          end

          def add_line
            lines.insert(add_line_index, new_gem_line)
          end

          def add_line_index
            (gems_lines_start_index..(lines.count - 1)).each do |e|
              return e if new_gem_line < lines[e]
            end
            lines.count
          end

          def gems_lines_start_index
            lines.index { |line| line.start_with?(DEPENDENCY_PREFIX) } || lines.count
          end

          def new_gem_line
            ([gem_line_prefix] + quoted_gem_specs).join(', ')
          end

          def gem_line_prefix
            "#{DEPENDENCY_PREFIX} '#{gem_name}'"
          end

          def replace_line
            lines[existing_gem_line_index] = new_gem_line
          end

          def quoted_gem_specs
            gem_specs.map { |gem_spec| "'#{gem_spec}'" }
          end
        end
      end
    end
  end
end
