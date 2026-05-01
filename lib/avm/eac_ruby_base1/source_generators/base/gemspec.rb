# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module SourceGenerators
      class Base < ::Avm::SourceGenerators::Base
        module Gemspec
          GEMSPEC_TAB = '  '
          GEMSPEC_NEWLINE_TAB = "\n#{GEMSPEC_TAB * 6}".freeze

          # @return [String]
          def gemspec_extra
            gemspec_extra_lines.map { |line| "\n#{IDENT}#{line}" }.join
          end

          # @return [Array<String>]
          def gemspec_extra_lines
            []
          end

          # @return [String]
          def gemspec_files_value
            (
              gemspec_files_directory_paths_to_string_array +
                gemspec_files_file_paths_to_string_array
            ).join(" +#{GEMSPEC_NEWLINE_TAB}")
          end

          # @return [Array<String>]
          def gemspec_files_directory_paths
            GEMSPEC_FILES_DIRECTORY_PATHS
          end

          # @return [Array<String>]
          def gemspec_files_file_paths
            GEMSPEC_FILES_FILE_PATHS
          end

          # @return [Avm::VersionNumber]
          def minimum_ruby_version
            ::Avm::VersionNumber.new(
              ::Avm::EacRubyBase1::Instances::Mixin.default_ruby_version.segments[0..1]
            )
          end

          # @return [String]
          def require_ruby_version
            ">= #{minimum_ruby_version}"
          end

          protected

          # @return [Enumerable<String>]
          def gemspec_files_directory_paths_to_string_array
            gemspec_files_directory_paths.then do |v|
              next [] unless v.any?

              ["Dir.glob('{#{v.sort.join(',')}}/**/*', File::FNM_DOTMATCH)" \
               "#{GEMSPEC_NEWLINE_TAB}#{GEMSPEC_TAB}" \
               ".reject { |f| ['.', '..'].include?(File.basename(f)) }"]
            end
          end

          # @return [Enumerable<String>]
          def gemspec_files_file_paths_to_string_array
            gemspec_files_file_paths.then do |y|
              next [] unless y.any?

              r = y.sort.map { |e| "'#{e}'" }.join(', ')
              ["[#{r}]"]
            end
          end

          def generate_gemspec
            template_apply('gemspec', "#{name}.gemspec")
          end
        end
      end
    end
  end
end
