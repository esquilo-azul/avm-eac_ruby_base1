# frozen_string_literal: true

require 'avm/eac_ruby_base1/sources/base'
require 'avm/source_generators/base'
require 'eac_templates/core_ext'
require 'eac_ruby_utils/core_ext'

module Avm
  module EacRubyBase1
    module SourceGenerators
      class Base < ::Avm::SourceGenerators::Base
        IDENT = '  '
        JOBS = %w[root_directory gemspec root_lib version_lib static gemfile_lock].freeze
        TEMPLATE_VARIABLES = %w[lib_path name root_module].freeze

        enable_speaker
        enable_simple_cache
        require_sub __FILE__, include_modules: true

        def root_directory
          target_path
        end

        def name
          root_directory.basename.to_s
        end

        def lib_path
          name.split('-').join('/')
        end

        def perform
          infov 'Root directory', root_directory
          infov 'Gem name', name
          JOBS.each do |job|
            infom "Generating #{job.humanize}..."
            send("generate_#{job}")
          end
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

        def apply_to_root_directory(template, subpath)
          if template.is_a?(::EacTemplates::Variables::Directory)
            template.children.each do |child|
              apply_to_root_directory(child, subpath.join(child.basename))
            end
          elsif template.is_a?(::EacTemplates::Variables::File)
            template.apply_to_file(template_variables, root_directory.join(subpath))
          else
            raise "Unknown template object: #{template}"
          end
        end

        def generate_gemspec
          template_apply('gemspec', "#{name}.gemspec")
        end

        def generate_root_directory
          root_directory.mkpath
        end

        def generate_root_lib
          template_apply('root_lib', "lib/#{lib_path}.rb")
        end

        def generate_static
          template.child('static').apply(self, root_directory)
        end

        def generate_version_lib
          template_apply('version', "lib/#{lib_path}/version.rb")
        end

        def self_gem_uncached
          ::Avm::EacRubyBase1::Sources::Base.new(root_directory)
        end

        def template_apply(from, to)
          target = root_directory.join(to)
          target.dirname.mkpath
          template.child("#{from}.template").apply_to_file(self, target.to_path)
        end
      end
    end
  end
end
