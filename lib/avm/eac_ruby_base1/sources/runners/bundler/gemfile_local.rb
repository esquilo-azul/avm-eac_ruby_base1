# frozen_string_literal: true

require 'eac_cli/core_ext'

module Avm
  module EacRubyBase1
    module Sources
      module Runners
        class Bundler
          class GemfileLocal
            runner_with :help do
              bool_opt '-w', '--write', 'Write the Gemfile.local file.'
            end

            def run
              start_banner
              run_bundle
              siblings_banner
              write_gemfile_local
            end

            private

            def gemfile_local_path
              the_source.path.join('Gemfile.local')
            end

            def gemfile_local_content
              siblings.map { |s| sibling_gemfile_local_line(s) }.join
            end

            def on_unexisting_gemfile_local
              return yield unless gemfile_local_path.exist?

              ::EacRubyUtils::Fs::Temp.on_file do |temp_file|
                ::FileUtils.cp(gemfile_local_path, temp_file)
                begin
                  ::FileUtils.rm_f(gemfile_local_path)
                  yield
                ensure
                  ::FileUtils.cp(temp_file, gemfile_local_path)
                end
              end
            end

            def run_bundle
              on_unexisting_gemfile_local do
                the_source.bundle.execute!
              rescue ::RuntimeError
                the_source.bundle('update').execute!
              end
            end

            def sibling_gemfile_local_line(sibling)
              ["gem '#{sibling.gem_name}'", # rubocop:disable Style/StringConcatenation
               ["path: ::File.expand_path('",
                sibling.path.relative_path_from(the_source.path).to_path, "', __dir__)"].join,
               'require: false'].join(', ') + "\n"
            end

            def start_banner
              runner_context.call(:source_banner)
              infov 'Parent', the_source.parent
            end

            def siblings_banner
              infov 'Siblings', siblings.count
              siblings.each do |sibling|
                infov '  * ', sibling.relative_path
              end
            end

            def write_gemfile_local
              return unless parsed.write?

              infom "Writing #{gemfile_local_path}..."
              gemfile_local_path.write(gemfile_local_content)
            end

            def siblings_uncached
              the_source.parent.if_present([]) do |v|
                v.subs.select { |sub| dependency_sub?(sub) }
              end
            end

            def the_source
              runner_context.call(:source)
            end

            def dependency_sub?(sub)
              sub.is_a?(::Avm::EacRubyBase1::Sources::Base) &&
                sub.gem_name != the_source.gem_name &&
                the_source.gemfile_lock_gem_version(sub.gem_name).present?
            end
          end
        end
      end
    end
  end
end
