# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module Avm
  module EacRubyBase1
    module Sources
      class Update
        require_sub __FILE__
        enable_simple_cache
        enable_speaker
        common_constructor :source do
          perform
        end

        def bundle_update
          infom 'Running "bundle update"...'
          ruby_gem.bundle('update').execute!
          infom 'Running "bundle install"...'
          ruby_gem.bundle('install').execute!
        end

        protected

        def perform
          update_gemfile_lock
          update_subs
        end

        def update_gemfile_lock
          source.scm.commit_if_change(-> { update_gemfile_lock_commit_message }) do
            bundle_update
          end
        end

        def update_gemfile_lock_commit_message
          i18n_translate(__method__, __locale: source.locale)
        end

        def update_subs
          source.subs.each do |sub|
            ::Avm::EacRubyBase1::Sources::Update::SubUpdate.new(self, sub)
          end
        end

        def ruby_gem_uncached
          ::EacRubyGemsUtils::Gem.new(source.path)
        end
      end
    end
  end
end
