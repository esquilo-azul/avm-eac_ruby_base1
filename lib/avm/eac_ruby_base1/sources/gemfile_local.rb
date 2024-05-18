# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module Avm
  module EacRubyBase1
    module Sources
      class GemfileLocal
        enable_simple_cache
        common_constructor :source

        def dependency_sub?(sub)
          sub.is_a?(::Avm::EacRubyBase1::Sources::Base) &&
            sub.gem_name != source.gem_name &&
            source.gemfile_lock_gem_version(sub.gem_name).present?
        end

        # @return [String]
        def target_content
          siblings.map { |s| sibling_gemfile_local_line(s) }.join
        end

        # @return [Pathname]
        def target_path
          source.path.join('Gemfile.local')
        end

        def on_unexisting_gemfile_local
          return yield unless target_path.exist?

          ::EacRubyUtils::Fs::Temp.on_file do |temp_file|
            ::FileUtils.cp(target_path, temp_file)
            begin
              ::FileUtils.rm_f(target_path)
              yield
            ensure
              ::FileUtils.cp(temp_file, target_path)
            end
          end
        end

        def run_bundle
          on_unexisting_gemfile_local do
            source.bundle.execute!
          rescue ::RuntimeError
            source.bundle('update').execute!
          end
        end

        # @param sibling [?}
        # @return [String]
        def sibling_gemfile_local_line(sibling)
          ["gem '#{sibling.gem_name}'", # rubocop:disable Style/StringConcatenation
           ["path: ::File.expand_path('",
            sibling.path.relative_path_from(source.path).to_path, "', __dir__)"].join,
           'require: false'].join(', ') + "\n"
        end

        # @return [void]
        def write_target_file
          target_path.write(target_content)
        end

        private

        def siblings_uncached
          source.parent.if_present([]) do |v|
            v.subs.select { |sub| dependency_sub?(sub) }
          end
        end
      end
    end
  end
end
