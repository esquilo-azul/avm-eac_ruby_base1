# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module SourceGenerators
      class Base < ::Avm::SourceGenerators::Base
        module Gemspec
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
            "Dir[#{gemspec_files_paths.map { |path| "'#{path}'" }.join(', ')}]"
          end

          # @return [Array<String>]
          def gemspec_files_paths
            ["{#{gemspec_files_directory_paths.sort.join(',')}}/**/*"] +
              gemspec_files_file_paths.sort
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

          def generate_gemspec
            template_apply('gemspec', "#{name}.gemspec")
          end
        end
      end
    end
  end
end
