# frozen_string_literal: true

require 'avm/eac_ruby_base1/sources/base'
require 'avm/source_generators/base'
require 'eac_templates/core_ext'
require 'eac_ruby_utils/core_ext'

module Avm
  module EacRubyBase1
    module SourceGenerators
      class Base < ::Avm::SourceGenerators::Base
        GEMSPEC_FILES_DIRECTORY_PATHS = %w[lib].freeze
        GEMSPEC_FILES_FILE_PATHS = [].freeze
        IDENT = '  '
        JOBS = %w[gemspec root_lib version_lib gemfile_lock].freeze
        TEMPLATE_VARIABLES = %w[lib_path name root_module].freeze

        enable_speaker
        enable_simple_cache
        require_sub __FILE__, include_modules: true

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

        def lib_path
          name.split('-').join('/')
        end

        def root_module
          lib_path.camelize
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

        protected

        def generate_gemspec
          template_apply('gemspec', "#{name}.gemspec")
        end

        def generate_root_lib
          template_apply('root_lib', "lib/#{lib_path}.rb")
        end

        def generate_version_lib
          template_apply('version', "lib/#{lib_path}/version.rb")
        end

        # @return [EacTemplates::Modules::Base]
        def root_template
          template.child('static')
        end

        def self_gem_uncached
          ::Avm::EacRubyBase1::Sources::Base.new(target_path)
        end

        def template_apply(from, to)
          target = target_path.join(to)
          target.dirname.mkpath
          template.child(from).apply_to_file(self, target.to_path)
        end
      end
    end
  end
end
