# frozen_string_literal: true

require 'eac_cli/core_ext'

module Avm
  module EacRubyBase1
    module Sources
      module Runners
        class Bundler
          class GemfileLock
            require_sub __FILE__, include_modules: true
            runner_with :help do
              desc 'Manipulage a "Gemfile.lock" file.'
              bool_opt '-c', '--continue', 'Continue Git rebase/cherry-pick.'
              bool_opt '-i', '--install', 'Run "bundle install".'
              bool_opt '-u', '--update', 'Run "bundle update".'
              bool_opt '-r', '--recursive', 'Run until Git rebase/cherry-pick is finished.'
              bool_opt '-a', '--all', 'Same as "-cirud".'
              bool_opt '-d', '--delete', 'Delete Gemfile.lock'
            end

            def run
              loop do
                git_reset_checkout
                delete_gemfile_lock
                bundle_update
                bundle_install
                git_continue
                break if complete?
              end
            end

            private

            def complete?
              !option_or_all?(:recursive) || !conflict?
            end

            def delete_gemfile_lock
              return unless check_capability(__method__, nil, :delete)

              ::FileUtils.rm_f(gemfile_lock)
            end

            def rebasing?
              instance.git_repo.root_path.join('.git', 'rebase-merge').exist?
            end

            def bundle_install
              return unless check_capability(__method__, :ruby_gem, :install)

              infom '"bundle install"...'
              bundle_run('install')
            end

            def bundle_update
              return unless check_capability(__method__, :ruby_gem, :update)

              infom '"bundle update"...'
              bundle_run('update')
            end

            def gemfile_lock
              'Gemfile.lock'
            end

            def bundle_run(*args)
              instance.ruby_gem.bundle(*args).system!
            end

            def conflict?
              rebase_conflict? || cherry_conflict?
            end

            def rebase_conflict?
              instance.git_repo.root_path.join('.git', 'REBASE_HEAD').exist?
            end

            def cherry_conflict?
              instance.git_repo.root_path.join('.git', 'CHERRY_PICK_HEAD').exist?
            end

            def option_or_all?(option)
              parsed[option] || parsed.all?
            end

            def instance
              runner_context.call(:instance)
            end

            def check_capability(caller, capability, option)
              return false unless option.blank? || option_or_all?(option)
              return true if capability.if_present(true) { |v| instance.respond_to?(v) }

              warn "Cannot run #{caller}: instance has no capability \"#{capability}\""
              false
            end
          end
        end
      end
    end
  end
end
