# frozen_string_literal: true

require 'avm/eac_generic_base0/sources/base'
require 'eac_ruby_utils/core_ext'

module Avm
  module EacRubyBase1
    module Sources
      class Base < ::Avm::EacGenericBase0::Sources::Base
        module Rubygems
          GEMSPEC_EXTNAME = '.gemspec'

          def gem_name
            gem_name_by_gemspec || gem_name_by_path
          end

          def gem_name_by_gemspec
            gemspec_path.if_present { |v| v.basename(GEMSPEC_EXTNAME).to_path }
          end

          def gem_name_by_path
            fullname = path.basename.to_s
            /\A(.+)(?:-\d+(?:\.\d+)*)\z/.if_match(fullname, false) { |m| m[1] }.if_present(fullname)
          end

          def gem_namespace_parts
            gem_name.split('-')
          end

          # @return [Gem::Specification]
          def gemspec
            ::Gem::Specification.load(gemspec_path.to_path)
          end

          # @return [Pathname]
          def gemspec_path
            path.glob("*#{GEMSPEC_EXTNAME}").first
          end
        end
      end
    end
  end
end
