# frozen_string_literal: true

require 'avm/eac_generic_base0/sources/base'
require 'eac_ruby_utils/core_ext'

module Avm
  module EacRubyBase1
    module Sources
      class Base < ::Avm::EacGenericBase0::Sources::Base
        module Rake
          RAKEFILE_BASENAME = 'Rakefile'
          RAKE_TASKS_LINE_PARSER = /\Arake\s+(\S+)\s+/.to_parser do |m|
            m[1]
          end

          # @return [Avm::EacRubyBase1::Sources::Base::BundleCommand]
          def rake(*args)
            raise "File \"#{rakefile_path}\" does not exist" unless rakefile_path.exist?

            bundle('exec', 'rake', '--rakefile', rakefile_path, *args)
          end

          # @return [Pathname]
          def rakefile_path
            path.join(RAKEFILE_BASENAME)
          end

          # @return [Array<String>]
          def rake_tasks
            rake('--all', '--tasks').execute!.each_line
              .map { |line| RAKE_TASKS_LINE_PARSER.parse!(line) }
          end
        end
      end
    end
  end
end
