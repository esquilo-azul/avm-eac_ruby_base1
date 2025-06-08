# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Sources
      class Base < ::Avm::EacGenericBase0::Sources::Base
        module Version
          # @return [Avm::VersionNumber]
          def version
            version_file.value.if_present { |v| ::Avm::VersionNumber.new(v) }
          end

          def version=(value)
            version_file.value = value
          end

          # @return [Avm::EacRubyBase1::Rubygems::VersionFile]
          def version_file
            ::Avm::EacRubyBase1::Rubygems::VersionFile.new(version_file_path)
          end

          def version_file_path
            path.join('lib', *gem_namespace_parts, 'version.rb')
          end
        end
      end
    end
  end
end
