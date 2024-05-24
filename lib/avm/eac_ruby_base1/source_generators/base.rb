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

        def lib_path
          name.split('-').join('/')
        end

        def perform
          infov 'Root directory', target_path
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

        def generate_gemspec
          template_apply('gemspec', "#{name}.gemspec")
        end

        def generate_root_directory
          target_path.mkpath
        end

        def generate_root_lib
          template_apply('root_lib', "lib/#{lib_path}.rb")
        end

        def generate_static
          template.child('static').apply(self, target_path)
        end

        def generate_version_lib
          template_apply('version', "lib/#{lib_path}/version.rb")
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
